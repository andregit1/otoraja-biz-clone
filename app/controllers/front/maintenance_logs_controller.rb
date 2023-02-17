class Front::MaintenanceLogsController < Front::ApiController
  protect_from_forgery :except => [:create, :update, :destroy, :restore]
  before_action :set_current_staff, only:[:create, :update, :destroy, :restore]
  before_action :set_maintenance_log, only: [:update]

  include AwsCognito
  include AwsSns
  include CheckIn
  include Checkout

  def show
    @maintenance_log = policy_scope(MaintenanceLog).find(params[:id])
  end

  def last
    @maintenance_log = policy_scope(MaintenanceLog).get_histories_by_customer_id(params[:customer_id]).first
    render 'show'
  end

  def create
    shop = current_user.shops.first
    ActiveRecord::Base.transaction do
      ml_param = maintenance_log_params
      mld_param = ml_param.delete('maintenance_log_details')
      ml_main_param = ml_param.delete('maintenanced_staff')
      @maintenance_log = MaintenanceLog.new(ml_param)
      @maintenance_log.maintained_staff = ShopStaff.find(ml_main_param[:id]) if ml_main_param.present?
      @maintenance_log.maintenance_log_details = mld_param.map do |mld|
        mld_destroy = mld.delete('_destroy')
        mlm_param = mld.delete('maintenance_mechanics')
        mrp_param = mld.delete('maintenance_log_detail_related_products')
        product_param = mld.delete('shop_product')
        mld_model = if mld[:id] < 0
          mld[:id] = nil
          MaintenanceLogDetail.new(mld)
        else
          MaintenanceLogDetail.find(mld[:id])
        end
        mld_model.maintenance_mechanics = mlm_param.map do |mlm|
          mlm_destroy = mlm.delete('_destroy')
          staff_param = mlm.delete('shop_staff')
          mlm_model = if mlm[:id] < 0
            mlm[:id] = nil
            MaintenanceMechanic.new(mlm)
          else
            MaintenanceMechanic.find(mlm[:id])
          end
          mlm_model.shop_staff = ShopStaff.find(staff_param[:id])
          if mlm[:id].present? && mlm[:id] > 0
            mlm_model.update!(mlm)
          end
          if mlm_destroy == true
            mlm_model.destroy!
            next
          end
          mlm_model
        end.compact if mlm_param.present?

        mld_model.maintenance_log_detail_related_products = mrp_param.map do |mrp|
          related_product_param = mrp.delete('shop_product')
          mrp_model = if mrp[:id] == nil
            MaintenanceLogDetailRelatedProduct.new(mrp)
          else
            MaintenanceLogDetailRelatedProduct.find(mrp[:id])
          end
          mrp_model.shop_product = ShopProduct.find(related_product_param[:id])
          if mrp[:id].present? && mrp[:id] > 0
            mrp_model.update!(mrp)
          end
          mrp_model
        end.compact if mrp_param.present?

        if product_param[:id].present?
          mld_model.shop_product = ShopProduct.find(product_param[:id])
        end
        if mld[:id].present? && mld[:id] > 0
          mld_model.update!(mld)
        end
        if mld_destroy == true
          mld_model.destroy!
          next
        end
        mld_model
      end.compact if mld_param.present?

      customer = if customer_params[:id].blank?
        cus = if customer_params[:tel].present?
          Customer.find_by(tel: customer_params[:tel]) || Customer.new(customer_params)
        else
          Customer.new(customer_params)
        end
        cus
      else
        Customer.find_by(id: customer_params[:id])
      end

      checkin = Checkin.new(customer: customer, shop: shop, datetime: DateTime.now, checkout_datetime: nil,  deleted: false)
      checkin.datetime = checkin_params[:datetime] if date_valid?(checkin_params[:datetime])
      checkin.checkout_datetime = checkin_params[:checkout_datetime] if date_valid?(checkin_params[:checkout_datetime])
      checkin.save!

      # cognito 登録
      activation_customer(customer) if customer.tel.present?
      checkin.update!(datetime: checkin_params[:datetime]) if date_valid?(checkin_params[:datetime])
      @maintenance_log.checkin = checkin
      @maintenance_log.save!
      reflect_customer

      # CustomerをElasticsearchに登録する
      Customer.es_import_by_id(@maintenance_log.checkin.customer.id)

      unless params[:do_save] == true
        send_sms = params[:receipt_output_method].include?('SMS')
        send_wa = params[:receipt_output_method].include?('WhatsApp')
        send_dm = customer.send_dm || (send_sms || send_wa)

        payment_method = PaymentMethod.find(payment_method_params[:id])

        do_checkout(checkin, payment_method)
        send_receipt_after_checkout(checkin, send_sms, send_wa) if send_dm
        checkin.update!(checkout_datetime: DateTime.now) if !checkin.checkout_datetime.present?
        checkin.update!(checkout_datetime: checkin_params[:checkout_datetime]) if date_valid?(checkin_params[:checkout_datetime])
        checkin.update!(is_checkout: true)
      end
    end # Transaction END

    render 'show'
  end

  def update
    ActiveRecord::Base.transaction do
      ml_param = maintenance_log_params
      mld_param = ml_param.delete('maintenance_log_details')
      ml_main_param = ml_param.delete('maintenanced_staff')
      @maintenance_log.maintained_staff = ShopStaff.find(ml_main_param[:id]) if ml_main_param.present?
      @maintenance_log.maintenance_log_details = mld_param.map do |mld|
        mld_destroy = mld.delete('_destroy')
        mlm_param = mld.delete('maintenance_mechanics')
        mrp_param = mld.delete('maintenance_log_detail_related_products')
        product_param = mld.delete('shop_product')
        mld_model = if mld[:id] < 0
          mld[:id] = nil
          MaintenanceLogDetail.new(mld)
        else
          MaintenanceLogDetail.find(mld[:id])
        end
        mld_model.maintenance_mechanics = mlm_param.map do |mlm|
          mlm_destroy = mlm.delete('_destroy')
          staff_param = mlm.delete('shop_staff')
          mlm_model = if mlm[:id] < 0
            mlm[:id] = nil
            MaintenanceMechanic.new(mlm)
          else
            MaintenanceMechanic.find(mlm[:id])
          end
          mlm_model.shop_staff = ShopStaff.find(staff_param[:id])
          if mlm[:id].present? && mlm[:id] > 0
            mlm_model.update!(mlm)
          end
          if mlm_destroy == true
            mlm_model.destroy!
            next
          end
          mlm_model
        end.compact if mlm_param.present?

        mld_model.maintenance_log_detail_related_products = mrp_param.map do |mrp|
          related_product_param = mrp.delete('shop_product')
          mrp_model = if mrp[:id] == nil
            MaintenanceLogDetailRelatedProduct.new(mrp)
          else
            MaintenanceLogDetailRelatedProduct.find(mrp[:id])
          end
          mrp_model.shop_product = ShopProduct.find(related_product_param[:id])
          if mrp[:id].present? && mrp[:id] > 0
            mrp_model.update!(mrp)
          end
          mrp_model
        end.compact if mrp_param.present?

        if product_param[:id].present?
          mld_model.shop_product = ShopProduct.find(product_param[:id])
        end
        if mld[:id].present? && mld[:id] > 0
          mld_model.update!(mld)
        end
        if mld_destroy == true
          mld_model.destroy!
          next
        end
        mld_model
      end.compact if mld_param.present?
      @maintenance_log.update!(ml_param)

      customer = if customer_params[:id].present?
        find_customer = Customer.find_by(id: customer_params[:id])
        if find_customer.tel.blank? && customer_params[:tel].present?
          dup_tel_customer = Customer.find_by(tel: customer_params[:tel])
          if dup_tel_customer.present?
            find_customer = dup_tel_customer
          else
            find_customer.tel = customer_params[:tel]
            find_customer.save!
            # cognito 登録
            activation_customer(find_customer)
          end
        end
        find_customer
      else
        cus = if @maintenance_log.checkin.customer.tel.blank? && customer_params[:tel].present?
          @maintenance_log.checkin.customer.tel = customer_params[:tel]
          @maintenance_log.checkin.customer.save!
          @maintenance_log.checkin.customer
        else
          Customer.new(customer_params)
        end
        # cognito 登録
        activation_customer(cus)
        cus
      end
      checkin = @maintenance_log.checkin
      checkin.touch # Update updaetd_at every time
      checkin.update!(customer: customer)
      checkin.update!(datetime: checkin_params[:datetime]) if date_valid?(checkin_params[:datetime])
      checkin.update!(checkout_datetime: checkin_params[:checkout_datetime]) if date_valid?(checkin_params[:checkout_datetime])

      # カスタマー側の情報に反映する
      reflect_customer
      # CustomerをElasticsearchに登録する
      Customer.es_import_by_id(@maintenance_log.checkin.customer.id)

      unless params[:do_save] == true
        send_sms = params[:receipt_output_method].include?('SMS')
        send_wa = params[:receipt_output_method].include?('WhatsApp')
        send_dm = customer.send_dm || (send_sms || send_wa)
        payment_method = PaymentMethod.find(payment_method_params[:id])

        checkin.update!(checkout_datetime: DateTime.now) if !checkin.checkout_datetime.present?
        checkin.update!(checkout_datetime: checkin_params[:checkout_datetime]) if date_valid?(checkin_params[:checkout_datetime])
        checkin.update!(is_checkout: true)

        do_checkout(@maintenance_log.checkin, payment_method)
        send_receipt_after_checkout(@maintenance_log.checkin, send_sms, send_wa) if send_dm
      end
    end # Transaction END
    render 'show'
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        checkin = policy_scope(MaintenanceLog).find_by(id: params[:id])&.checkin
        checkin.deleted_checkin unless checkin.nil?
        response_no_content
      rescue
        response_no_content
      end
    end
  end

  def restore
    ActiveRecord::Base.transaction do
      begin
        checkin = policy_scope(MaintenanceLog).find_by(id: params[:id])&.checkin
        checkin.restore_checkin unless checkin.nil?
        response_no_content
      rescue
        response_no_content
      end
    end
  end

  def resend_whatsapp_receipt
    maintenance_log = policy_scope(MaintenanceLog).find(params[:id])
    maintenance_log.checkin.customer.wa_tel = params[:customer_tel]
    unless maintenance_log.nil?
      send_whatsapp_receipt(maintenance_log.checkin)
    end
  end

  def cost_estimation
    shop = current_user.shops.first
    ml_param = maintenance_log_params
    mld_param = ml_param.delete('maintenance_log_details')
    ml_main_param = ml_param.delete('maintenanced_staff')

    maintenance_log = MaintenanceLog.new(ml_param)
    maintenance_log.maintained_staff = ShopStaff.find(ml_main_param[:id]) if ml_main_param.present?

    if estimate_maintenance_log_params[:id].present?
      old_ml = MaintenanceLog.find(estimate_maintenance_log_params[:id])
      maintenance_log.total_down_payment_amount = old_ml.total_down_payment_amount
    end

    maintenance_log.maintenance_log_details = mld_param.map do |mld|
      mld_destroy = mld.delete('_destroy')
      mlm_param = mld.delete('maintenance_mechanics')
      mrp_param = mld.delete('maintenance_log_detail_related_products')
      product_param = mld.delete('shop_product')

      next if mld_destroy == true

      mld_model = if mld[:id] < 0
        mld[:id] = nil
        MaintenanceLogDetail.new(mld)
      else
        MaintenanceLogDetail.find(mld[:id])
      end

      mld_model.maintenance_mechanics = mlm_param.map do |mlm|
        mlm_destroy = mlm.delete('_destroy')
        staff_param = mlm.delete('shop_staff')

        next if mlm_destroy == true

        mlm_model = if mlm[:id] < 0
          mlm[:id] = nil
          MaintenanceMechanic.new(mlm)
        else
          MaintenanceMechanic.find(mlm[:id])
        end
        
        mlm_model.shop_staff = ShopStaff.find(staff_param[:id])
        if mlm[:id].present? && mlm[:id] > 0
          mlm_model.assign_attributes(mlm)
        end
        mlm_model
      end.compact if mlm_param.present?

      mld_model.maintenance_log_detail_related_products = mrp_param.map do |mrp|
        related_product_param = mrp.delete('shop_product')
        mrp_model = if mrp[:id] == nil
          MaintenanceLogDetailRelatedProduct.new(mrp)
        else
          MaintenanceLogDetailRelatedProduct.find(mrp[:id])
        end
        mrp_model.shop_product = ShopProduct.find(related_product_param[:id])
        if mrp[:id].present? && mrp[:id] > 0
          mrp_model.assign_attributes(mrp)
        end
        mrp_model
      end.compact if mrp_param.present?

      if product_param[:id].present?
        mld_model.shop_product = ShopProduct.find(product_param[:id])
      end
      if mld[:id].present? && mld[:id] > 0
        mld_model.assign_attributes(mld)
      end
      mld_model
    end.compact if mld_param.present?

    customer = if customer_params[:id].blank?
      Customer.new(customer_params)
    else
      Customer.find_by(id: customer_params[:id])
    end

    checkin = Checkin.new(maintenance_log: maintenance_log, customer: customer, shop: shop, datetime: (checkin_params[:datetime] || DateTime.now), checkout_datetime: checkin_params[:checkout_datetime], deleted: false)

    send_cost_estimation(checkin)
  end
  
  def list_update_price
    maintenance_log_details_params = params["maintenance_log_details"]
    @maintenance_log_details = []
    maintenance_log_details_params.each do |mld|
      maintenance_log_detail = MaintenanceLogDetail.find(mld["id"])
      ActiveRecord::Base.transaction do
        maintenance_log_detail.unit_price = maintenance_log_detail.shop_product.sales_unit_price
        maintenance_log_detail.sub_total_price = maintenance_log_detail.shop_product.sales_unit_price * maintenance_log_detail.quantity
        maintenance_log_detail.gross_profit = maintenance_log_detail.shop_product.sales_unit_price * maintenance_log_detail.quantity
        maintenance_log_detail.save!
      end
      @maintenance_log_details << maintenance_log_detail
    end

    render 'list_update_price'
  end

  def down_payment_histories
    @maintenance_log = policy_scope(MaintenanceLog).find(params[:id])
    @down_payment_histories = @maintenance_log.cash_flow_histories.where(cash_type: "DOWN_PAYMENT")
  end

  def down_payment_save
    @maintenance_log = policy_scope(MaintenanceLog).find(params[:id])
    
    @down_payment = @maintenance_log.cash_flow_histories.new(down_payment_params)
    @down_payment.save

    @maintenance_log.total_down_payment_amount = @maintenance_log.sum_cashable_amount
    @maintenance_log.save 

    if @down_payment.sent_wa_receipt
      # create digital down payment payment
      send_down_payment_with_receipt(@maintenance_log.checkin)
    end
  end

  def down_payment_update
    @maintenance_log = policy_scope(MaintenanceLog).find(params[:id])

    if !@maintenance_log.checkin.is_checkout
      @down_payment = @maintenance_log.cash_flow_histories.where(id: down_payment_update_params[:id]).first
      unless @down_payment.blank?
        @down_payment.cash_paid_date = down_payment_update_params[:cash_paid_date]
        @down_payment.save
      end
    end
    response_dp_process
  end

  def down_payment_destroy
    @maintenance_log = policy_scope(MaintenanceLog).find(params[:id])

    if !@maintenance_log.checkin.is_checkout
      @down_payment = @maintenance_log.cash_flow_histories.where(id: down_payment_update_params[:id]).first
      unless @down_payment.blank?
        @down_payment.destroy
        @maintenance_log.total_down_payment_amount = @maintenance_log.sum_cashable_amount
        @maintenance_log.save 
      end
    end
    response_dp_process
  end

private
  def set_current_staff
    ShopStaff.current_staff = ShopStaff.find_by(id: front_staff_params[:id]) if front_staff_params[:id].present?
  end

  def down_payment_update_params
    params.fetch(:down_payment, {}).permit(
      :id,
      :cash_paid_date
    )
  end

  def response_dp_process
    render :json => { :status => @down_payment.present? ? true : false, 
                      :message => @down_payment.present? ? 'Data has been successfully updated.' : 'Can\'t process data.', 
                      :params => down_payment_update_params }
  end

  def down_payment_params
    params.fetch(:down_payment, {}).permit(
      :cash_amount,
      :cash_paid_date,
      :cash_in_out,
      :cash_type,
      :sent_wa_receipt,
      :ref_id,
      :ref_table
    )
  end

  def front_staff_params
    params.fetch(:front_staff, {}).permit(
      :id,
    )
  end

  def payment_method_params
    params.fetch(:payment_method, {}).permit(
      :id,
    )
  end

  def customer_params
    params.fetch(:maintenance_log, {}).fetch(:checkin, {}).fetch(:customer, {}).permit(
      :id,
      :name,
      :tel,
      :terms_agreed_at,
      :send_dm,
    )
  end

  def checkin_params
    params.fetch(:maintenance_log, {}).fetch(:checkin, {}).permit(
      :id,
      :datetime,
      :checkout_datetime,
    )
  end

  def maintenance_log_params
    params.fetch(:maintenance_log, {}).permit(
      :name,
      :maker,
      :model,
      :number_plate_area,
      :number_plate_number,
      :number_plate_pref,
      :expiration_month,
      :expiration_year,
      :color,
      :previous_odometer,
      :previous_odometer_updated_at,
      :odometer,
      :remarks,
      :total_price,
      :amount_paid,
      :adjustment,
      maintenanced_staff:[
        :id
      ],
      maintenance_log_details: [
        :id,
        :name,
        :product_no,
        :description,
        :quantity,
        :unit_price,
        :discount_type,
        :discount_rate,
        :discount_amount,
        :sub_total_price,
        :remarks,
        :_destroy,
        shop_product: [
          :id,
        ],
        maintenance_mechanics: [
          :id,
          :_destroy,
          shop_staff: [
            :id
          ]
        ],
        maintenance_log_detail_related_products: [
          :id,
          :category_name,
          :product_no,
          :item_name,
          :item_detail,
          :quantity,
          shop_product: [
            :id,
          ],
        ]
      ]
    )
  end

def estimate_maintenance_log_params
  params.fetch(:maintenance_log, {}).permit(
    :id
  )
end

  def set_maintenance_log
    maintenance_log = MaintenanceLog.find(params[:id])
    unless maintenance_log.adjustment.nil?
      maintenance_log.total_price = maintenance_log.total_price + maintenance_log.adjustment
    end
    @maintenance_log = maintenance_log
    @customer = @maintenance_log&.checkin&.customer
  end

  def reflect_customer
    customer = @maintenance_log.checkin.customer

    # 名前が登録されていなければ更新
    unless customer.name.present?
      customer.update(name: maintenance_log_params[:name])
    end

    # カスタマと車体の紐付け
    if maintenance_log_params[:maker].present? ||
      maintenance_log_params[:model].present? ||
      maintenance_log_params[:color].present?
      bike = customer.bikes.find_by(
        maker: maintenance_log_params[:maker],
        model: maintenance_log_params[:model],
        color: maintenance_log_params[:color],
      )
      bike.odometer = maintenance_log_params[:odometer] if bike.present? && maintenance_log_params[:odometer].present?
    end

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
        maintenance_log_params[:number_plate_number].present?
        # 新規の車体番号を登録する
        owned_bike = OwnedBike.create(
          customer: customer,
          number_plate_area: maintenance_log_params[:number_plate_area],
          number_plate_number: maintenance_log_params[:number_plate_number],
          number_plate_pref: maintenance_log_params[:number_plate_pref] ? maintenance_log_params[:number_plate_pref].upcase : '',
          expiration_month: maintenance_log_params[:expiration_month],
          expiration_year: maintenance_log_params[:expiration_year],
        )
        if maintenance_log_params[:maker].present? ||
          maintenance_log_params[:model].present? ||
          maintenance_log_params[:color].present? ||
          maintenance_log_params[:odometer].present?
          if bike.nil?
            bike = Bike.create(
              maker: maintenance_log_params[:maker],
              model: maintenance_log_params[:model],
              color: maintenance_log_params[:color],
              odometer: maintenance_log_params[:odometer],
            )
          end
          owned_bike.update(bike: bike)
        end
      else
        # 車体番号を登録せず、車種のみ登録する
        if maintenance_log_params[:maker].present? ||
          maintenance_log_params[:model].present? ||
          maintenance_log_params[:color].present? ||
          maintenance_log_params[:odometer].present?
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
      if maintenance_log_params[:number_plate_area].present? &&
        maintenance_log_params[:number_plate_number].present? &&
        maintenance_log_params[:number_plate_pref].present?
        owned_bike.update(
          number_plate_area: maintenance_log_params[:number_plate_area],
          number_plate_number: maintenance_log_params[:number_plate_number],
          number_plate_pref: maintenance_log_params[:number_plate_pref].upcase,
        )
      end
      owned_bike.update(
        expiration_month: maintenance_log_params[:expiration_month],
        expiration_year: maintenance_log_params[:expiration_year],
      )
      if owned_bike.bike.nil?
        if bike.nil?
          bike = Bike.create(
              maker: maintenance_log_params[:maker],
              model: maintenance_log_params[:model],
              color: maintenance_log_params[:color],
              odometer: maintenance_log_params[:odometer],
            )
        end
        owned_bike.update(bike: bike)
      else
        owned_bike.bike.update(
          maker: maintenance_log_params[:maker],
          model: maintenance_log_params[:model],
          color: maintenance_log_params[:color]
        )
        owned_bike.bike.update(odometer: maintenance_log_params[:odometer]) if maintenance_log_params[:odometer].present?
      end
    end
  end

  def date_valid?(str)
    !! Date.parse(str) rescue false
  end
end
