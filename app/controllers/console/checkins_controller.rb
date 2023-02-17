class Console::CheckinsController < Console::ApplicationConsoleController  
  def index
    @shop_id = params[:select_shop].present? ? params[:select_shop] : params[:shop_id]
    @mode = mode = params[:mode].to_sym
    if (params[:start_date].present? && params[:start_date] != 'Invalid date')
      @start_date =  ApplicationController.helpers.formattedDateTimePicker(params[:start_date]) 
      @end_date = ApplicationController.helpers.formattedDateTimePicker(params[:end_date])
    end
    filtered_params

    @checkins = if (@start_date.present? && @end_date.present?)
                  Checkin.where(shop_id: @shop_id.present? ? @shop_id : Shop.first.id).where("CONVERT_TZ(#{@base_date}, 'UTC', 'ASIA/JAKARTA') BETWEEN '%s' AND '%s'", @start_date, @end_date)
                else
                  Checkin.where(shop_id: @shop_id.present? ? @shop_id : Shop.first.id)
                end
    @checkins = set_checkin_list_condition(mode, @checkins)
    @checkin = set_checkin_list_condition(mode, @checkins).find{|m| m.checkin_no == params[:no_trx]} if params[:no_trx].present?
    
    @checkins = @checkins.order(@search_sort_selected).page(params[:page] || 1).per(params[:per_page] || 10)
  end

  def show
    @checkin = Checkin.find(params[:id])
    @mode = set_status
  end

  private

  def filtered_params
    @search_no_trx = "" == "" ? @search_no_trx : params[:no_trx] 
    @search_base_date = {'Tgl. msk': 'datetime', 'Tgl. keluar': 'checkout_datetime'}
    @base_date =  if @mode == :checkout
                    (params[:base_date] || 'checkout_datetime').to_sym
                  else
                    (params[:base_date] || 'datetime').to_sym
                  end
    @search_sort = if @mode == :all 
                    {
                      'Tgl. Masuk ↓': 'datetime desc',
                      'Tgl. Masuk ↑': 'datetime asc', 
                      'Tgl. Selesai ↓': 'checkout_datetime desc',
                      'Tgl. Selesai ↑': 'checkout_datetime asc', 
                      'Update Terkini': 'updated_at desc'
                    }
                  elsif @mode == :checkout 
                    {
                      'Tgl. Masuk ↓': 'datetime desc',
                      'Tgl. Masuk ↑': 'datetime asc',  
                      'Tgl. Selesai ↓': 'checkout_datetime desc',
                      'Tgl. Selesai ↑': 'checkout_datetime asc'
                    }
                  else
                    {
                      'Tgl. Masuk ↓': 'datetime desc',
                      'Tgl. Masuk ↑': 'datetime asc', 
                      'Update Terkini': 'updated_at desc'
                    }
                  end
    @search_sort_selected = params[:order] || 'datetime desc'
  end

  def set_checkin_list_condition(mode, checkins)
    if mode == :all
      checkins = checkins.where(deleted: false)
    elsif mode == :uncheckout
      checkins = checkins.where(is_checkout: false).where(deleted: false)
    elsif mode == :checkout
      checkins = checkins.where(is_checkout: true).where(deleted: false)
    elsif mode == :deleted
      checkins = checkins.where(deleted: true)
    end
    checkins
  end

  def set_status
    if @checkin.is_checkout && @checkin.deleted == false
      mode = 'SELESAI'
    elsif !@checkin.is_checkout && @checkin.deleted == false
      mode = 'DIPROSES'
    elsif @checkin.deleted == true
      mode = 'VOID'
    end
    mode
  end
 end
  