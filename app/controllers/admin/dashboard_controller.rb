class Admin::DashboardController < Admin::ApplicationAdminController
  before_action :set_shop_group, only:[:index]
  def index
    ajax_action unless params[:ajax_handler].blank?
    @available_shop_plan = current_user.shops
    
    @shop = Shop.find(session[:default_user_shop])
    @owner_setup_incomplite = @shop.initial_setup.blank? && current_user.owner?

    if @owner_setup_incomplite
      @has_initial_shop = @shop.valid?(:update_shop)
      @has_initial_staff = @shop.shop_staffs.present?
      @has_initial_user = @shop.has_staff_account? | @shop.has_manager_account? | @shop.has_shop_manager_account?
      @owner_setup_complite = @has_initial_shop && @has_initial_staff && @has_initial_user
    end
  end

  def update_initial_setup
    shop = Shop.find(session[:default_user_shop])
    shop.update(initial_setup: true)
    redirect_to admin_dashboard_index_path
  end

  def ajax_action
    if params[:ajax_handler] == 'handle_dashboard'
      # Ajaxの処理
      @start_datetime = DateTime.parse(params[:start_date])
      @end_datetime = DateTime.parse(params[:end_date])
      shop_id = if params[:dashboard_shop].present?
        params[:dashboard_shop]
      else
        current_user&.shops&.first&.id
      end
      sales_aggregation_unit = params[:sales_aggregation_unit][:type]
      checkins_aggregation_unit = params[:checkins_aggregation_unit][:type]
      revenue_aggregation_unit = params[:revenue_aggregation_unit][:type]
      profit_aggregation_unit = params[:profit_aggregation_unit][:type]
      expenses_aggregation_unit = params[:expenses_aggregation_unit][:type]

      # @sales_details = MaintenanceLogDetail.aggregate_sales_details(shop_id, Otoraja::DateUtils.parse_date_tz(params[:start_date]), Otoraja::DateUtils.parse_end_date_tz(params[:end_date]))
      # @sales_details_by_product = MaintenanceLogDetail.aggregate_sales_details_by_product(shop_id, Otoraja::DateUtils.parse_date_tz(params[:start_date]), Otoraja::DateUtils.parse_end_date_tz(params[:end_date]))
      # @sales_details_json = @sales_details_by_product.take(10).to_json
      # @sales_details_categories = @sales_details.pluck(:id, :name) || []
      
      @checkins_chart_data = generate_checkins_chart_data(@start_datetime, @end_datetime, shop_id, checkins_aggregation_unit)
      @total_checkins = @checkins_chart_data.values.inject(:+)
      
      @sales_chart_data = generate_sales_chart_data(@start_datetime, @end_datetime, shop_id, sales_aggregation_unit)
      @total_sales = @sales_chart_data.values.inject(:+)
      
      @sales_by_mechanic = generate_mechanic_sales_details(shop_id, @start_datetime, @end_datetime)
      @sales_by_payment_type = translateToID(generate_sales_by_payment_type(shop_id, @start_datetime, @end_datetime))

      @gross_expenses = generate_gross_expense_chart_data(@start_datetime, @end_datetime, shop_id, expenses_aggregation_unit)
      @gross_profit = generate_gross_profit_chart_data(@start_datetime, @end_datetime, shop_id, revenue_aggregation_unit)
      @gross_sales = generate_gross_sales_chart_data(@start_datetime, @end_datetime, shop_id, revenue_aggregation_unit)
      @gross_down_payment = generate_aggregate_gross_down_payment(@start_datetime, @end_datetime, shop_id, revenue_aggregation_unit)
      @gross_discount = generate_gross_discount_chart_data(@start_datetime, @end_datetime, shop_id, revenue_aggregation_unit)

      @total_expenses = @gross_expenses.values.inject(:+)
      @total_revenue = @gross_sales.values.inject(:+)
      @total_down_payment = @gross_down_payment.values.inject(:+)
      @total_discount = @gross_discount.values.inject(:+) 
      @total_profit = @gross_profit.values.inject(:+) - @total_discount

      @gross_discount_chart_data = @gross_discount
      @gross_profit_chart_data = generate_gross_profit_data(@gross_profit, @gross_discount)
      @gross_sales_chart_data = generate_cost_of_goods_sold_data(@gross_sales, @gross_profit)

      @profit_by_product_chart_data = generate_profit_by_product(@start_datetime, @end_datetime, shop_id, profit_aggregation_unit)

      if @checkins_chart_data.size > 0 && @sales_chart_data.size > 0
        render
      else
        render json: 'no data'
      end
    end
  end

  private
    def generate_mechanic_sales_details(shop_id, start_datetime, end_datetime)
       ShopStaff.aggregate_mechanic_sales_details(shop_id, start_datetime, end_datetime)
    end

    def generate_sales_by_payment_type(shop_id, start_datetime, end_datetime)
       MaintenanceLogPaymentMethod.aggregate_sales_by_payment_type(shop_id, start_datetime, end_datetime)
    end

    def conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
      case aggregation_unit
      when 'Harian' then
        if start_datetime.to_date == end_datetime.to_date
          hours = [*0..23].map{|time|[format('%02d',time),0]}.to_h
          chart_data = hours.merge(aggregate_data)
        else
          dates = (start_datetime.to_date..end_datetime.to_date).to_a.map{|date| [date.strftime('%Y-%m-%d'),0]}.to_h
          chart_data = dates.merge(aggregate_data)
        end
      when 'Mingguan' then
        week_nums = (start_datetime.to_date..end_datetime.to_date).to_a.map{|date| [date.strftime('%Y-%V'),0]}.to_h
        chart_data = week_nums.merge(aggregate_data)

        # 週毎の日付範囲を生成
        week_ranges = (start_datetime.to_date..end_datetime.to_date).map{|date| "#{date.year\
          }/#{date.beginning_of_week > start_datetime.to_date ? \
          format('%02d',date.beginning_of_week.month) + '/' + format('%02d',date.beginning_of_week.day) : \
          format('%02d',start_datetime.to_date.month) + '/' + format('%02d',start_datetime.to_date.day)\
          }~#{date.end_of_week < end_datetime.to_date ? \
          format('%02d',date.end_of_week.month) + '/' + format('%02d',date.end_of_week.day) : \
          format('%02d',end_datetime.to_date.month) + '/' + format('%02d',end_datetime.to_date.day)\
          }"}.uniq

        # 表のラベルを週番号から週の日付範囲に変換
        range_data = {}
        week_ranges.each_with_index do |week, weeks_index|
          chart_data.keys.each_with_index do |key, data_index|
            if data_index === weeks_index
              range_data[week] = chart_data[key]
            end
          end
        end
        chart_data = range_data
      when 'Bulanan' then
        months = (start_datetime.to_date..end_datetime.to_date).map{|date| [date.strftime('%B, %Y'),0]}.to_h
        chart_data = months.merge(aggregate_data)
      end
    end

    def generate_sales_chart_data(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_sales_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_checkins_chart_data(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_checkins_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_gross_sales_chart_data(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_gross_sales_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_aggregate_gross_down_payment(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_gross_down_payment(shop_id, start_datetime, end_datetime, aggregate_format)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_gross_profit_chart_data(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_gross_profit_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_gross_expense_chart_data(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_gross_expense_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_gross_discount_chart_data(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_gross_discount_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_profit_by_product(start_datetime, end_datetime, shop_id, aggregation_unit)
      aggregate_format = generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      aggregate_data = generate_profit_by_product_data(shop_id, start_datetime, end_datetime, aggregate_format, aggregation_unit)
      conversion_aggregated_data(aggregate_data, start_datetime, end_datetime, aggregation_unit)
    end

    def generate_profit_by_product_data(shop_id, start_datetime, end_datetime, aggregate_format, x)
      dataset = []
      dataset = MaintenanceLogDetail.get_profit_by_product(shop_id, start_datetime, end_datetime, aggregate_format)
     
      labels = {}
      #create time series lables and data used to later to
      #calculate value for each data point of that item
      dataset.each do |data|
        if labels[data.label].nil?
          labels[data.label] = []
        end
        labels[data.label].push({:name => data.name, :value => data.gross_profit})
      end

      profit_datasets = {}
      #hash with unique keys (product alias name) only
      #as each item is a data set in chart.js
      dataset.each_with_index do |data, index|
        profit_datasets[data.name] = index
      end
      
      @profit_chart_datasets = profit_datasets
      labels
    end

    def generate_sales_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      dataset = []
      dataset = MaintenanceLogDetail.aggregate_sales(shop_id, start_datetime, end_datetime, aggregate_format)
      hash = {}
      dataset.each do |data|
        hash[data.label] = data.total.nil? ? 0 : data.total
      end
      hash
    end

    def generate_gross_sales_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      dataset = []
      dataset = MaintenanceLogDetail.aggregate_gross_sales(shop_id, start_datetime, end_datetime, aggregate_format)
      hash = {}
      dataset.each do |data|
        hash[data.label] = data.total.nil? ? 0 : data.total
      end
      hash
    end

    def generate_gross_expense_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      dataset = []
      dataset = ShopExpense.aggregate_gross_expenses(shop_id, start_datetime, end_datetime, aggregate_format)
      hash = {}
      dataset.each do |data|
        hash[data.label] = data.total.nil? ? 0 : data.total
      end
      hash
    end

    def generate_gross_down_payment(shop_id, start_datetime, end_datetime, aggregate_format)
      dataset = []
      dataset = MaintenanceLogDetail.aggregate_gross_down_payment(shop_id, start_datetime, end_datetime, aggregate_format)
      hash = {}
      dataset.each do |data|
        hash[data.label] = data.total.nil? ? 0 : data.total
      end
      hash
    end

    def generate_gross_profit_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      dataset = []
      dataset = MaintenanceLogDetail.aggregate_gross_profit(shop_id, start_datetime, end_datetime, aggregate_format)
      hash = {}
      dataset.each do |data|
        hash[data.label] = data.total.nil? ? 0 : data.total
      end
      hash
    end

    def generate_gross_discount_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      dataset = []
      dataset = MaintenanceLogDetail.aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format, 'discount_amount')
      hash = {}
      dataset.each do |data|
        hash[data.label] = data.total.nil? ? 0 : data.total
      end
      hash
    end

    def generate_cost_of_goods_sold_data(gross_sales, gross_profit)
      hash = {}
      gross_sales.each do |key, value|
        hash[key] = value - gross_profit[key]; 
      end
      hash
    end

    def generate_gross_profit_data(gross_profit, gross_discount)
      hash = {}
      gross_profit.each do |key, value|
        hash[key] = value - gross_discount[key]; 
      end
      hash
    end

    def generate_checkins_aggregate_data(shop_id, start_datetime, end_datetime, aggregate_format)
      dataset = []
      dataset = Checkin.aggregate_visitors(shop_id, start_datetime, end_datetime, aggregate_format)
      hash = {}
      dataset.each do |data|
        hash[data.label] = data.total.nil? ? 0 : data.total
      end
      hash
    end

    def generate_aggregate_format(start_datetime, end_datetime, aggregation_unit)
      case aggregation_unit
      when 'Harian' then
        if start_datetime.to_date == end_datetime.to_date
          '%H'
        else
          '%Y-%m-%d'
        end
      when 'Mingguan' then
        '%Y-%v'
      when 'Bulanan' then
        '%M, %Y'
      else
        ''
      end
    end

    def set_shop_group
      @shop = current_user.shops
      @shop_group = ShopGroup.find(@shop.first.shop_group_id)
    end
       
    def translateToID(sales_by_payment_type)
      sales_by_payment_type.each do |detail|
        case detail.name
        when "Cash"
          detail.name = "Tunai"
        when "Credit/Debit"
          detail.name = "Kredit/Debet"
        when "Invoice"
          detail.name = "Faktur"
        when "EDC"
          detail.name = "EDC"
        when "Other"
          detail.name = "Lainnya"
        end
      end
    end
  end