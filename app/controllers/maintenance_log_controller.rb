class MaintenanceLogController < ApplicationController
  include AwsCognito
  include AwsSns
  include CheckIn
  include Checkout

  skip_before_action :verify_authenticity_token, only:[:send_confirm_sms]

  before_action :set_maintenance_log, only: [:show, :edit, :update, :destroy, :resist_phone_number]
  before_action :set_checkin_id, only: [:show, :edit, :update, :resist_phone_number]
  before_action :build_country_code_list, only:[:show, :edit, :update, :new, :create]
  before_action :latest_terms, only:[:new, :create, :edit, :update, :show]
  before_action :set_display_info, only:[:new, :create]

  def index
  end

  def new
    if params[:copy_maintenance_log_id].present?
      past_maintenance_log = policy_scope(MaintenanceLog).find_by_id(params[:copy_maintenance_log_id])
      init_values = past_maintenance_log.slice(
        'name',
        'number_plate_area',
        'number_plate_number',
        'number_plate_pref',
        'expiration_month',
        'expiration_year',
        'maker',
        'model',
        'color'
      ) unless past_maintenance_log.nil?
      @customer = past_maintenance_log&.checkin&.customer
    end
    
    @checkin_no = nil;
    @maintenance_log = MaintenanceLog.new(init_values)
    @config = ShopConfig.find(current_user.shop_ids.first)
    
  end

  def edit
    @products = ShopProduct.get_products(current_user.shop_ids).limit(100)
    @checkin = policy_scope(Checkin).find(params[:checkin_id])
    @checkin_no = @checkin.checkin_no
    @maintenance_log_histories = policy_scope(MaintenanceLog).get_histories(@checkin)
    @mechanics = ShopStaff.own_shop(current_user.shop_ids.first).active_mechanics
    @payment_methods = current_user.shops.first.payment_methods
    @bikes = OwnedBike.get_bikes(@checkin.customer_id)
    @config = ShopConfig.find(current_user.shop_ids.first)
  end

  def show
    edit
  end

  def create
    shop = current_user.shops.first
    if customer_params[:id].blank?
      customer = Customer.new(customer_params)
    else
      customer = Customer.find_by(id: customer_params[:id])
      # customer.update(customer_params)
    end
    
    checkin = do_checkin(customer,shop)
    # cognito 登録
    activation_customer(customer) if customer.tel.present?
    checkin.update(datetime: checkin_params[:datetime]) if date_valid?(checkin_params[:datetime])
    @maintenance_log = MaintenanceLog.new(maintenance_log_params)
    @maintenance_log.checkin_id = checkin.id
    if @maintenance_log.save
      # カスタマー側の情報に反映する
      reflect_customer

      # CustomerをElasticsearchに登録する
      Customer.es_import_by_id(@maintenance_log.checkin.customer.id)

      if params[:is_form_save] == 'true'
        # saveの場合はeditへ遷移する
        redirect_to edit_maintenance_log_path(@maintenance_log.checkin), notice: 'Maintenance Log was successfully created.' 
      else
        send_sms = params[:receipt_output_method_sms] === 'sms'
        send_wa = params[:send_type] === 'wa' || 'sms_wa'
        send_dm = ActiveRecord::Type::Boolean.new.cast(params[:send_dm])
        payment_method = PaymentMethod.find(params[:payment_method_id])

        do_checkout(checkin, payment_method)

        send_receipt_after_checkout(checkin,send_sms, send_wa) if send_dm
        checkin.update(checkout_datetime: checkin_params[:checkout_datetime]) if date_valid?(checkin_params[:checkout_datetime])

        if params[:receipt_output_method_paper] === 'paper'
          redirect_to pdf_viewer_path(path: receipt_output_for_stores_path(checkin), back: 'new_maintenance_log'), notice: 'Maintenance Log was successfully created.' 
        else
          redirect_to new_maintenance_log_path, notice: 'Maintenance Log was successfully created.', flash: {success: 'Checked out'}
        end
      end

    else
      render :new
    end
  end
  
  def update
    customer = if customer_params[:id].present?
      find_customer = Customer.find_by(id: customer_params[:id])
      if find_customer.tel.blank? && customer_params[:tel].present?
        find_customer.tel = customer_params[:tel]
        find_customer.save
        # cognito 登録
        activation_customer(find_customer)
      end
      find_customer
    else
      cus = if @maintenance_log.checkin.customer.tel.blank? && customer_params[:tel].present?
        @maintenance_log.checkin.customer.tel = customer_params[:tel]
        @maintenance_log.checkin.customer.save
        @maintenance_log.checkin.customer
      else
        Customer.new(customer_params)
      end
      # cognito 登録
      activation_customer(cus)
      cus
    end
    checkin = @maintenance_log.checkin
    if checkin.update(customer: customer) && @maintenance_log.update(maintenance_log_params)
      # カスタマー側の情報に反映する
      reflect_customer

      # CustomerをElasticsearchに登録する
      Customer.es_import_by_id(@maintenance_log.checkin.customer.id)

      # チェックイン時間更新
      @maintenance_log.checkin.update(datetime: checkin_params[:datetime]) if date_valid?(checkin_params[:datetime])
      checkin.touch # Update updaetd_at every time

      if params[:is_form_save] == 'true'
        # チェックアウト時間更新
        @maintenance_log.checkin.update(checkout_datetime: checkin_params[:checkout_datetime]) if date_valid?(checkin_params[:checkout_datetime])

        # saveは同じ画面を表示する
        redirect_to edit_maintenance_log_path(@maintenance_log.checkin), notice: 'Maintenance Log was successfully created.' 
      else
        send_sms = params[:receipt_output_method_sms] === 'sms'
        send_wa = params[:send_type] === 'wa'
        send_dm = ActiveRecord::Type::Boolean.new.cast(params[:send_dm])
        payment_method = PaymentMethod.find(params[:payment_method_id])

        do_checkout(@maintenance_log.checkin, payment_method)
        send_receipt_after_checkout(@maintenance_log.checkin, send_sms, send_wa) if send_dm

        # チェックアウト時間更新
        @maintenance_log.checkin.update(checkout_datetime: checkin_params[:checkout_datetime]) if date_valid?(checkin_params[:checkout_datetime])

        if params[:receipt_output_method_paper] === 'paper'
          redirect_to pdf_viewer_path(path: receipt_output_for_stores_path(@maintenance_log.checkin), back: 'new_maintenance_log'), notice: 'Maintenance Log was successfully created.' 
        else
          redirect_to new_maintenance_log_path, notice: 'Maintenance Log was successfully created.', flash: {success: 'Checked out'}
        end
      end
    else
      edit
      render :edit
    end
  end

  def update_customer
    respond_to do |format|
      if @maintenance_log.update(maintenance_log_params)
        # カスタマー側の情報に反映する
        reflect_customer
        format.html {redirect_to edit_maintenance_log_path, notice: 'Maintenance Log was successfully updated.'}
        format.json {render :json => {status: 'success'}}
      else
        format.html {render :edit_order}
        format.json {render :json => {status: 'fail'}}
      end
    end

  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        checkin = policy_scope(Checkin).find(params[:checkin_id])
        checkin.deleted_checkin unless checkin.nil?
        redirect_to new_maintenance_log_path, notice: 'Maintenance Log was successfully destroyed.'
      rescue
        redirect_to new_maintenance_log_path, notice: 'An Error has Occured.'
      end
    end
  end

  def send_confirm_sms
    phone = Phonelib.parse(params[:phone_country_code] + params[:phone_national])
    if phone.valid?
      tel = phone.international(false)
      send_sms(tel, I18n.t('sms.regist_message'))
      send_wa_notification(tel)
      status = {status:'valid', tel: tel, valid: true, tel_national_hyphen: phone.national()}
    else
      status = {status:'invalid', tel: tel, valid: false}
    end
    render :json => status
  end

  # def resist_phone_number
  #   phone = Phonelib.parse(params[:phone_country_code] + params[:phone_national])
  #   tel = phone.international(false)
  #   customer = Customer.find_by(tel: tel)
  #   if customer.nil?
  #     # 電話番号が登録されていない場合
  #     (ses, id, pw) = regist_cognito(tel)
  #     activation_cognito(id, pw, ses)
  #     if @maintenance_log.checkin.customer.tel.present?
  #       # メンテナンスログに紐づくカスタマーの電話番号が設定されている場合
  #       # 新規でカスタマーを作成し、紐づけなおす
  #       customer = Customer.create(tel: tel, cognito_id: id, cognito_pw: pw)
  #       @maintenance_log.checkin.customer = customer
  #       @maintenance_log.checkin.save
  #       response = {status:'new', tel: phone.international}
  #     else
  #       # メンテナンスログに紐づくカスタマーの電話番号が設定されていない場合
  #       # カスタマーの情報を更新する
  #       customer = @maintenance_log.checkin.customer
  #       customer.tel = tel
  #       customer.cognito_id = id
  #       customer.cognito_pw = pw
  #       customer.save
  #       response = {status:'new', tel: phone.international}
  #     end
  #   else
  #     # 電話番号が登録されている場合
  #     # チェックインに紐づくカスタマーを更新する
  #     @maintenance_log.checkin.customer = customer
  #     @maintenance_log.checkin.save
  #     response = {status:'exists', tel: phone.international}
  #   end
  #   render :json => response
  # end

  private
    def set_maintenance_log
      maintenance_log = MaintenanceLog.find_by(checkin_id: params[:checkin_id])
      unless maintenance_log&.adjustment.nil?
        maintenance_log.total_price = maintenance_log.total_price + maintenance_log.adjustment
      end
      @maintenance_log = maintenance_log
      @customer = @maintenance_log&.checkin&.customer
    end

    def set_checkin_id
      @checkin_id = params[:checkin_id]
    end

    def set_display_info
      @mechanics = ShopStaff.own_shop(current_user.shop_ids.first).active_mechanics
      @products = ShopProduct.get_products(current_user.shop_ids).limit(100)
      @payment_methods = current_user.shops.first.payment_methods
    end

    def build_country_code_list
      @country_code_list = {
        '+1' => '1',
        '+62' => '62',
        '+81' => '81'
      }
    end

    def maintenance_log_params
      params.fetch(:maintenance_log, {}).permit(
        :checkin_id,
        :name,
        :reason,
        :maker,
        :model,
        :displacement,
        :number_plate_area,
        :number_plate_number,
        :number_plate_pref,
        :expiration_month,
        :expiration_year,
        :mileage,
        :color,
        :remarks,
        :total_price,
        :maintained_staff_id,
        :amount_paid,
        :adjustment,
        maintenance_log_details_attributes: [
          :id,
          :maintenance_menu_id,
          :name,
          :product_no,
          :description,
          :quantity,
          :unit_price,
          :discount_type,
          :discount_rate,
          :discount_amount,
          :shop_product_id,
          :sub_total_price,
          :remarks,
          :_destroy,
          maintenance_log_detail_related_products_attributes: [
            :id,
            :product_no,
            :shop_product_id,
            :category_name,
            :item_name,
            :item_detail,
            :quantity
          ],
          maintenance_mechanics_attributes: [
            :id,
            :maintenance_log_detail_id,
            :shop_staff_id,
            :_destroy
          ]
        ]
      )
    end

    def customer_params
      params.fetch(:customer, {}).permit(
        :id,
        :name,
        :tel,
        :terms_agreed_at,
        :send_dm,
        :receipt_type,
        :send_type,
        :wa_tel
      )
    end

    def checkin_params
      params.fetch(:checkin, {}).permit(
        :datetime,
        :checkout_datetime,
      )
    end

    def reflect_customer
      customer = @maintenance_log.checkin.customer
      
      # 名前が登録されていなければ更新
      unless customer.name.present?
        customer.update(name: maintenance_log_params[:name])
      end
  
      # カスタマと車体の紐付け
      bike = customer.bikes.find_by(
        maker: maintenance_log_params[:maker],
        model: maintenance_log_params[:model],
        color: maintenance_log_params[:color],
      )
      if maintenance_log_params[:number_plate_area].present? &&
        maintenance_log_params[:number_plate_number].present? &&
        maintenance_log_params[:number_plate_pref].present?
        owned_bike = customer.owned_bikes.find_by(
          number_plate_area: maintenance_log_params[:number_plate_area],
          number_plate_number: maintenance_log_params[:number_plate_number],
          number_plate_pref: maintenance_log_params[:number_plate_pref].upcase
          )
      else
        unless bike.nil?
          owned_bike = bike.owned_bike
        end
      end
  
      if owned_bike.nil?
        if maintenance_log_params[:number_plate_area].present? &&
          maintenance_log_params[:number_plate_number].present? &&
          maintenance_log_params[:number_plate_pref].present?
          # 新規の車体番号を登録する
          owned_bike = OwnedBike.create(
            customer: customer,
            number_plate_area: maintenance_log_params[:number_plate_area],
            number_plate_number: maintenance_log_params[:number_plate_number],
            number_plate_pref: maintenance_log_params[:number_plate_pref].upcase,
            expiration_month: maintenance_log_params[:expiration_month],
            expiration_year: maintenance_log_params[:expiration_year],
          )
          if maintenance_log_params[:maker].present? ||
            maintenance_log_params[:model].present?
            if bike.nil?
              bike = Bike.create(
                maker: maintenance_log_params[:maker],
                model: maintenance_log_params[:model],
                color: maintenance_log_params[:color],
              )
            end
            owned_bike.update(bike: bike)
          end
        else
          # 車体番号を登録せず、車種のみ登録する
          if maintenance_log_params[:maker].present? ||
            maintenance_log_params[:model].present?
            if bike.nil?
              bike = Bike.create(
                maker: maintenance_log_params[:maker],
                model: maintenance_log_params[:model],
                color: maintenance_log_params[:color],
              )
            end
            OwnedBike.create(
              customer: customer,
              bike: bike,
              number_plate_area: '',
              number_plate_number: '',
              number_plate_pref: '',
            )
          end
        end
      else
        owned_bike.update(
          number_plate_area: maintenance_log_params[:number_plate_area],
          number_plate_number: maintenance_log_params[:number_plate_number],
          number_plate_pref: maintenance_log_params[:number_plate_pref].upcase,
          expiration_month: maintenance_log_params[:expiration_month],
          expiration_year: maintenance_log_params[:expiration_year],
        )
        if owned_bike.bike.nil?
          if bike.nil?
            bike = Bike.create(
                maker: maintenance_log_params[:maker],
                model: maintenance_log_params[:model],
                color: maintenance_log_params[:color],
              )
          end
          owned_bike.update(bike: bike)
        else
          owned_bike.bike.update(
            maker: maintenance_log_params[:maker],
            model: maintenance_log_params[:model],
            color: maintenance_log_params[:color],
          )
        end
      end
    end

    def latest_terms
      @terms = Term.where('effective_date <= ?', DateTime.now).where(terms_purpose: :to_bengkel).order('effective_date DESC').first
    end

    def date_valid?(str)
      !! Date.parse(str) rescue false
    end

    def is_optin(customer)
      unless customer.nil?
        #get whats_app_service for sending receipt
        #must ensure that the service db has been seeded
        @service_id = WhatsAppService.where(name: "payments").first()&.id
    
        @optin = Customer.where(id: customer.id).joins(:whats_app_optins).select("whats_app_optins.*").where(id: @service_id).first()
    
        return @optin.nil? ? { result: false } : { result: true }
      else
        return false
      end
    end
    
  end
