class CustomersController < ApplicationController
  include AwsCognito
  include AwsSns
  include CheckIn

  before_action :latest_terms, only:[:checkin]
  before_action :build_country_code_list, only:[:checkin, :register, :past_checkin]
  before_action :checkin_mode, only:[:checkin, :register]

  def checkin
    if request.post?
      @phone_country_code = params[:phone_country_code]
      @phone_national = params[:phone_national]
      @number_plate_area = params[:number_plate_area]
      @number_plate_number = params[:number_plate_number]
      @number_plate_pref = params[:number_plate_pref].upcase

      if params[:phone_checkin].present?
        tel = params[:phone_country_code] + params[:phone_national]
        phone = Phonelib.parse(tel)
        tel = phone.international(false)

        customer = Customer.find_by(tel: tel)
        if customer.nil?
          # 存在しない電話番号
          logger.debug('電話番号フォーマットOK')
          # 電話番号のフォーマットとして妥当であれば、同意画面へ遷移する
          @tel = phone.international(false)
          render :agreement
        else
          # 存在する電話番号
          if toAgree(customer)
            # 同意した規約が古いか、読んでない
            @customer_id = customer.id
            render :agreement
          else
            # チェックインする
            shop = current_user.shops.first
            create_checkin(customer, shop)
          end
        end
      elsif params[:plate_checkin].present?
        # ナンバープレートチェックイン
        # ナンバープレートが登録されているか検索
        owned_bike = OwnedBike.find_by(
          number_plate_area: @number_plate_area,
          number_plate_number: @number_plate_number,
          number_plate_pref: @number_plate_pref
        )
        if owned_bike.nil?
          # 存在しないナンバープレート
          render :agreement
        else
          customer = owned_bike.customer
          # 存在するナンバープレート
          if toAgree(customer)
            # 同意した規約が古いか、読んでない
            @customer_id = customer.id
            render :agreement
          else
            # チェックインする
            shop = current_user.shops.first
            create_checkin(customer, shop, {
              number_plate_area: @number_plate_area,
              number_plate_number: @number_plate_number,
              number_plate_pref: @number_plate_pref
              })
          end
        end
      elsif params[:suggest_checkin].present?
        customer = policy_scope(Customer).find(params[:customer_id])
        shop = current_user.shops.first
        create_checkin(customer, shop)
      elsif params[:anonymous].present?
        # 空のCustomerを作成し、チェックインレコードを作成する
        customer = Customer.create
        shop = current_user.shops.first
        create_checkin(customer, shop)
      end
    else
      @phone_country_code = '62'
      @phone_national = ''
      render :checkin
    end
  end

  # カスタマー登録
  def register
    # 規約から遷移
    if params[:agree].present?
      if params[:tel].present?
        logger.debug('電話番号で新規登録フロー')
        res = regist_cognito(params[:tel])
        send_sms(params[:tel], I18n.t('sms.regist_message'))
        send_wa_notification(params[:tel])
        set_params(
          params[:tel],
          params[:send_dm],
          res[1], # cognito_id
          res[2], # cognito_pw
          res[0], # session
        )
        render :register
      else
        if params[:customer_id].present?
          # すでにカスタマーが存在する場合は、規約同意の日時を記録するだけ
          logger.debug('規約を読んでチェクイン')
          customer = Customer.find(params[:customer_id])
          customer.terms_agreed_at = DateTime.now
          customer.save
        else
          # 無名チェックインで規約を読ませることも想定
          customer = Customer.create(
            send_dm: params[:send_dm],
            terms_agreed_at: DateTime.now
          )
          if params[:number_plate_area].present?
            logger.debug('ナンバープレートで新規登録フロー')
            owned_bike = OwnedBike.create(
              customer: customer,
              number_plate_area: params[:number_plate_area],
              number_plate_number: params[:number_plate_number],
              number_plate_pref: params[:number_plate_pref].upcase
            )
          end
        end
        shop = current_user.shops.first
        if params[:number_plate_area].present?
          # ナンバープレートでチェックイン
          create_checkin(customer, shop, {
            number_plate_area: params[:number_plate_area],
            number_plate_number: params[:number_plate_number],
            number_plate_pref: params[:number_plate_pref].upcase
            })
        else
          # ナンバープレート以外でチェックイン
          create_checkin(customer, shop)
        end
      end
    end

    # SMS再送
    if params[:resend].present?
      logger.debug('SMS再送')
      if params[:phone_national].blank?
        # 電話番号未入力
        logger.debug('電話番号未入力')
        set_params(
          params[:tel],
          params[:send_dm],
          params[:cognito_id],
          params[:cognito_pw],
          params[:session],
        )
        @phone_national = params[:phone_national]
        @phone_country_code = params[:phone_country_code]
        flash.now[:danger] = 'Phone number required'
        return
      end
      tel = params[:phone_country_code] + params[:phone_national]
      # 妥当性チェック
      phone = Phonelib.parse(tel)
      unless phone.valid?
        logger.debug('電話番号フォーマットNG')
        set_params(
          params[:tel],
          params[:send_dm],
          params[:cognito_id],
          params[:cognito_pw],
          params[:session]
        )
        @phone_national = params[:phone_national]
        @phone_country_code = params[:phone_country_code]
        flash.now[:danger] = 'Invalid format phone number'
        return
      end
      tel = phone.international(false)

      if params[:tel] == tel
        # そのまま再送する
        send_sms(params[:tel], I18n.t('sms.regist_message'))
        send_wa_notification(params[:tel])
        set_params(
          params[:tel],
          params[:send_dm],
          params[:cognito_id],
          params[:cognito_pw],
          params[:session],
        )
        flash.now[:info] = "SMS resend to #{params[:tel]}"
        render :register
      else
        # 電話番号に変更がある場合、customerにあるかチェックする
        customer = Customer.find_by(tel: tel)
        if customer.nil?
          # 存在しない電話番号
          res = regist_cognito(tel)
          send_sms(tel, I18n.t('sms.regist_message'))
          send_wa_notification(tel)
          set_params(
            tel,
            params[:send_dm],
            res[1], # cognito_id
            res[2], # cognito_pw
            res[0], # session
          )
          flash.now[:info] = "SMS resend to #{tel}"
          render :register
        else
          # 存在する電話番号
          # チェックインする
          shop = current_user.shops.first
          create_checkin(customer, shop)
        end
      end
    end

    # 顧客登録を行う
    if params[:register].present?
      # MFAを有効化する
      activation_cognito(
        params[:cognito_id],
        params[:cognito_pw],
        params[:session]
        )
      # 顧客登録を行う
      customer = Customer.create(
        tel: params[:tel],
        cognito_id: params[:cognito_id],
        cognito_pw: params[:cognito_pw],
        send_dm: params[:send_dm],
        terms_agreed_at: DateTime.now
      )
      shop = current_user.shops.first
      create_checkin(customer, shop)
    end
  end

  def past_checkin
    # WIB(ジャカルタ時間)取得
    now = DateTime.now.in_time_zone('Jakarta')
    @today = Date.new(now.year, now.month, now.day)
    @checkin_day = params[:checkin_day] || @today
    @checkedout_day = @checkin_day
    if request.get?
      @phone_country_code = '62'
      @phone_national = ''
      @checkedout = '1'
      return
    end

    # 入力エラー時用に、パラメータを戻す
    set_params_past_checkin

    checkin_day = Date.parse(params[:checkedin_day])
    checkin_date = DateTime.parse("#{checkin_day.year}-#{checkin_day.month}-#{checkin_day.day} #{params[:checkedin_hour].to_i}:#{params[:checkedin_min].to_i}:00 +0700")
    if params[:checkedout] == '1'
      checkout_day = Date.parse(params[:checkedout_day])
      checkout_date = DateTime.parse("#{checkout_day.year}-#{checkout_day.month}-#{checkout_day.day} #{params[:checkedout_hour].to_i}:#{params[:checkedout_min].to_i}:00 +0700")
      if checkin_date > checkout_date
        flash.now[:danger] = 'Tanggal check-out lebih lambat dari tanggal check-in. (checkedin > checkedout)'
        return
      end
    else
      checkout_date = nil
    end
    unless params[:reason].present?
      flash.now[:danger] = 'reason required'
      return
    end
    # 電話番号もしくはナンバープレートが入力されている場合はカスタマー取得する
    # 電話番号優先
    if params[:phone_national].present?
      tel = params[:phone_country_code] + params[:phone_national]
      # 妥当性チェック
      phone = Phonelib.parse(tel)
      unless phone.valid?
        logger.debug('電話番号フォーマットNG')
        flash.now[:danger] = 'Invalid format phone number'
        return
      end
      tel = phone.international(false)
      customer = Customer.find_by(tel: tel)
      if customer.nil?
        logger.debug('電話番号に紐づくカスタマーがいなかった')
        # Cognitoに登録する
        res = regist_cognito(tel)
        activation_cognito(res[1], res[2], res[0])
        # 新たにカスタマーレコードを作成する
        customer = Customer.new
        customer.tel = tel
        customer.send_dm = true
        customer.cognito_id = res[1]
        customer.cognito_pw = res[2]
        customer.terms_agreed_at = DateTime.now
        customer.save
      else
        logger.debug('電話番号に紐づくカスタマーがいた')
      end
      owned_bikes = customer.owned_bikes.find_by(
        number_plate_area: params[:number_plate_area],
        number_plate_number: params[:number_plate_number],
        number_plate_pref: params[:number_plate_pref].upcase
      )
      if valid_numberplate && owned_bikes.blank?
        OwnedBike.create(
          customer: customer,
          number_plate_area: params[:number_plate_area],
          number_plate_number: params[:number_plate_number],
          number_plate_pref: params[:number_plate_pref].upcase,
          expiration_month: params[:expiration_month],
          expiration_year: params[:expiration_year]
        )
      end
    elsif valid_numberplate
      # ナンバープレートが登録されているか検索
      owned_bike = OwnedBike.find_by(
        number_plate_area: params[:number_plate_area],
        number_plate_number: params[:number_plate_number],
        number_plate_pref: params[:number_plate_pref].upcase
        )
      if owned_bike.nil?
        logger.debug('ナンバープレートに紐づくカスタマーがいなかった')
        customer = Customer.new
        customer.send_dm = true
        customer.terms_agreed_at = DateTime.now
        customer.save
        owned_bike = OwnedBike.create(
          customer: customer,
          number_plate_area: params[:number_plate_area],
          number_plate_number: params[:number_plate_number],
          number_plate_pref: params[:number_plate_pref].upcase,
          expiration_month: params[:expiration_month],
          expiration_year: params[:expiration_year]
        )
      else
        logger.debug('ナンバープレートに紐づくカスタマーがいた')
        customer = owned_bike.customer
      end
    else
      # 名無しカスタマー
      customer = Customer.new
      customer.send_dm = true
      customer.terms_agreed_at = DateTime.now
      customer.save
    end
    # チェックインを作る
    shop = current_user.shops.first
    checkin = Checkin.create(
      customer: customer,
      shop: shop,
      datetime: checkin_date,
      checkout_datetime: checkout_date,
      deleted: false
    )
    # メンテナンスログを作成する
    maintenance_log = MaintenanceLog.new
    maintenance_log.checkin = checkin
    maintenance_log.reason = params[:reason]
    if valid_numberplate
      maintenance_log.number_plate_area = params[:number_plate_area]
      maintenance_log.number_plate_number = params[:number_plate_number]
      maintenance_log.number_plate_pref = params[:number_plate_pref]
      maintenance_log.expiration_month = params[:expiration_month]
      maintenance_log.expiration_year = params[:expiration_year]
    end
    maintenance_log.maker = params[:maker]
    maintenance_log.model = params[:model]
    maintenance_log.color = params[:color]
    maintenance_log.save!
    redirect_to edit_maintenance_log_path(checkin)

  end

  private
    # ナンバープレートチェック
    def valid_numberplate
      return params[:number_plate_area].present? && params[:number_plate_number].present? && params[:number_plate_pref].present?
    end

    # チェックインし、画面遷移する
    def create_checkin(customer, shop, number_plate = nil)
      checkin = Checkin.create(customer: customer, shop: shop, datetime: DateTime.now, deleted: false)
      if number_plate.nil?
        redirect_to new_maintenance_log_path(checkin)
      else
        redirect_to new_maintenance_log_path(
          checkin_id: checkin.id,
          number_plate_area: number_plate[:number_plate_area],
          number_plate_number: number_plate[:number_plate_number],
          number_plate_pref: number_plate[:number_plate_pref].upcase
          )
      end
    end

    # 画面にわたすパラメータ設定
    def set_params(tel, send_dm, cognito_id, cognito_pw, session)
      @customer = Customer.new
      @customer.tel = tel
      @customer.send_dm = send_dm
      @customer.cognito_id = cognito_id
      @customer.cognito_pw = cognito_pw
      @session = session
      phone = Phonelib.parse(tel)
      @phone_national = phone.national(false)
      @phone_country_code = phone.country_code
    end

    def build_country_code_list
      @country_code_list = {
        '+1' => '1',
        '+62' => '62',
        '+81' => '81'
      }
    end

    def latest_terms
      @terms = Term.where('effective_date <= ?', DateTime.now).where(terms_purpose: :to_bengkel).order('effective_date DESC').first
    end

    def toAgree(customer)
      if customer.terms_agreed_at.nil?
        return true
      else
        return @terms.effective_date > customer.terms_agreed_at
      end
    end

    def checkin_mode
      @mode = params[:mode] || 'phone_number'
    end

    def set_params_past_checkin
      @phone_country_code = params[:phone_country_code]
      @phone_national = params[:phone_national]
      @checkin_day = params[:checkedin_day]
      @checkedin_hour = params[:checkedin_hour]
      @checkedin_min = params[:checkedin_min]
      @checkedout_day = params[:checkedout_day] || @checkin_day
      @checkedout_hour = params[:checkedout_hour] || '00'
      @checkedout_min = params[:checkedout_min] || '00'
      @checkedout = params[:checkedout]
      @number_plate_area = params[:number_plate_area]
      @number_plate_number = params[:number_plate_number]
      @number_plate_pref = params[:number_plate_pref]
      @expiration_month = params[:expiration_month]
      @expiration_year = params[:expiration_year]
      @maker = params[:maker]
      @model = params[:model]
      @color = params[:color]
      @reason = params[:reason]
    end
end
