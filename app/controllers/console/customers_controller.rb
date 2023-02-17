class Console::CustomersController < Console::ApplicationConsoleController
  include AwsSns
  include ChangeTel
  before_action :build_country_code_list, only:[:edit_phone_number, :update_phone_number]

  def list
    order = params[:sort] || 'id desc'
    @q = policy_scope(Customer).left_joins(:owned_bikes).joins(:checkins).group('checkins.customer_id').select('customers.*, max(datetime) as last_visit_datetime').order(order).ransack(params[:q])
    @customers = @q.result.page(params[:page]).per(10)
    unless params[:commit].present?
      @customers = @customers.where.not('customers.name': ['', nil]).where.not('customers.tel': ['', nil]).where.not('owned_bikes.number_plate_number': ['', nil])
    else
      @customers = @customers.where.not('customers.name': ['', nil]) if customer_filter_params[:customer]&.include?('customer_name')
      @customers = @customers.where.not('customers.tel': ['', nil]) if customer_filter_params[:customer]&.include?('customer_tel')
      @customers = @customers.where.not('owned_bikes.number_plate_number': ['', nil]) if customer_filter_params[:customer]&.include?('customer_plat')
    end
  end

  def show
    @customer = policy_scope(Customer).find_by_id(params[:id])
  end

  def checkin
    @maintenance_log = policy_scope(MaintenanceLog).find(params[:maintenance_log_id])
  end

  def maintenance_logs
    @maintenance_logs = policy_scope(MaintenanceLog)
  end

  def checkins
    @checkins = policy_scope(Customer).find_by_id(params[:id]).checkins.exclude_system_created.page(params[:page]).per(10)
  end

  def owned_bikes

  end

  def edit
    @customer = policy_scope(Customer).find_by_id(params[:id])
  end

  def update
    customer = policy_scope(Customer).find_by_id(params[:id])
    customer.update(send_dm: params[:customer][:send_dm])
    redirect_to console_customer_show_path
  end

  def answers
    @customer_id = params[:id]
    @answers = Answer.joins({questionnaire: :checkin}).where(checkins: {customer_id: params[:id]}).includes(questionnaire: {checkin: :shop}).page(params[:page]).per(10)
  end

  def export
    respond_to do |format|
      format.csv {
        customers_csv = policy_scope(Customer).generate_csv(current_user)
        send_data customers_csv, filename: "customers_#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      }
    end
  end

  def import
    @customer_upload = CustomerUpload.new
  end

  def import_confirm
    @customer_upload = CustomerUpload.new(customer_upload_params)
    if @customer_upload.valid?
      @shop = Shop.find_by(id: @customer_upload.shop_id)
      @customers = @customer_upload.get_customers
      @customer_collection = CustomerCollection.new
      @add_customers_count = @customers.select{|h| h[:id].nil?}.count
      @exisiting_customers_count = @customers.count - @add_customers_count
    else
      render :import
    end
  end

  def import_execution
    @customer_collection = CustomerCollection.new(customer_collection_params)

    if @customer_collection.save
      redirect_to console_customers_import_path, flash: {info: 'Customer import successful.'}
    else
      redirect_to console_customers_import_path, flash: {danger: 'Customer import failed.'}
    end
  end

  def edit_phone_number
    @customer = policy_scope(Customer).find_by_id(params[:id])
    phone = Phonelib.parse(@customer.tel)
    @phone_country_code = phone.country_code || '62'
    @phone_national = phone.national(false)
  end

  def update_phone_number
    customer = policy_scope(Customer).find_by_id(params[:id])

    err_msg =''
    permited_params = customer_phone_params
    if permited_params[:phone_national].present?
      phone = Phonelib.parse(permited_params[:phone_country_code] + permited_params[:phone_national])
      # 妥当性チェック
      if phone.valid?
        tel = phone.international(false)
        customers = Customer.find_by(tel: tel)
        #  存在チェック
        if customers.blank?
          create_token_and_send_sms(customer, tel)
        else
          # 重複エラー
          err_msg = t('console.customer.duplicate_phone_number') + ': ' + tel
        end
      else
        # 妥当性エラー
        err_msg = t('warning.phone.invalid') + ': ' + permited_params[:phone_country_code] + permited_params[:phone_national]
      end
    else
      # 電話番号未入力
      err_msg = t('console.customer.blank_phone_number')
    end
    if err_msg.present?
      # エラーメッセージを表示
      redirect_to console_customer_edit_phone_number_path, flash: {danger: err_msg}
    else
      # showへリダイレクト
      redirect_to console_customer_show_path
    end
  end
  
  private

    def customer_upload_params
      params.fetch(:customer_upload, {}).permit(:shop_id, :file)
    end

    def customer_collection_params
      params.permit(:shop_id, customers: [:id, :tel, :name, :number_plate_area, :number_plate_number, :number_plate_pref, :expiration_month, :expiration_year, :maker, :model, :color])
    end

    def build_country_code_list
      @country_code_list = {
        '+1' => '1',
        '+62' => '62',
        '+81' => '81'
      }
    end

    def customer_phone_params
      params.fetch(:customer, {}).permit(:phone_country_code, :phone_national)
    end

    def customer_filter_params
      params.fetch(:filter, {}).permit(customer:[])
    end
end
