module AwsCognito
  extend ActiveSupport::Concern

  included do
    helper_method :regist_cognito
    helper_method :activation_cognito
  end

  def regist_cognito(param_tel)
    config = Aws::AwsUtility.config
    client = Aws::AwsUtility.CognitoIdentityProvider_client

    phone_number = "+#{param_tel}"

    # Cognito存在チェック
    resp = client.list_users({
      user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
      filter: "phone_number = \"#{phone_number}\""
    })
    unless resp.users.length == 0
      cognito_user = resp.users.first
      logger.info("Duplicate Cognito username:#{cognito_user.username} #{phone_number}")
      # すでに存在している場合は削除する
      client.admin_delete_user(
        user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
        username: cognito_user.username
      )
    end

    # パスワード生成
    password = password_gen
    username = SecureRandom.uuid
    try = 0
    begin
      try += 1
      resp = client.admin_create_user({
        user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
        username: username,
        temporary_password: password,
        user_attributes: [
          {
            name: 'phone_number',
            value: phone_number,
          },
          {
            name: 'phone_number_verified',
            value: 'True',
          },
        ],
        message_action: 'SUPPRESS',
      })
    rescue Aws::CognitoIdentityProvider::Errors::InvalidPasswordException => exception
      password = password_gen
      retry if try < 3
      raise exception
    end

    username = resp.user.username

    # 仮ユーザー登録
    resp = client.admin_initiate_auth({
      user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
      client_id: config['cognito_setting']['pool_data']['client_id'],
      auth_flow: 'ADMIN_NO_SRP_AUTH',
      auth_parameters: {
        USERNAME: username,
        PASSWORD: password,
      }
    })
    ses = resp.session
    return ses, username, password
  end

  # MFAを有効にする
  def activation_cognito(username, password, session)
    config = Aws::AwsUtility.config
    client = Aws::AwsUtility.CognitoIdentityProvider_client
    # パスワード更新(本ユーザー登録)
    resp = client.admin_respond_to_auth_challenge({
      user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
      client_id: config['cognito_setting']['pool_data']['client_id'],
      challenge_name: 'NEW_PASSWORD_REQUIRED',
      session: session,
      challenge_responses: {
        USERNAME: username,
        NEW_PASSWORD: password
      }
    })
    # フロントでの登録はあとから有効化する
    # MFA有効化
    # ユーザープールのCustom Authを使うため、MFAは有効化しない
    # resp = client.admin_set_user_mfa_preference({
    #   user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
    #   username: username,
    #   sms_mfa_settings: {
    #     enabled: true,
    #     preferred_mfa: true,
    #   },
    # })
  end

  def update_cognito_phone_number(bef_tel, param_tel)
    config = Aws::AwsUtility.config
    client = Aws::AwsUtility.CognitoIdentityProvider_client

    phone_number = "+#{param_tel}"
    bef_phone_number = "+#{bef_tel}"

    # Cognito存在チェック
    resp = client.list_users({
      user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
      filter: "phone_number = \"#{bef_phone_number}\""
    })
    cognito_user = resp.users.first

    resp = client.admin_update_user_attributes({
      user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
      username: cognito_user.username,
      user_attributes: [
        {
          name: "phone_number",
          value: phone_number,
        },
        {
          name: 'phone_number_verified',
          value: 'True',
        },
      ],
    })
  end

  private

  # パスワード生成
  def password_gen(length=8)
    numbers = [*0..9]
    alpha_bigs = [*'A'..'Z']
    alpha_smalls = [*'a'..'z']
    symbols = "! # $ % & @ + * ?".split(/\s+/)
    codes = [numbers, alpha_bigs, alpha_smalls, symbols].shuffle
    pwd = ''
    while (/\A(?=.*?[a-z])(?=.*?\d)(?=.*?[!-\/:-@\[-`{-~])[!-~]{8}+\z/i =~ pwd) == nil
      password = []
      length.times do |i|
        password << codes[i % codes.length].sample(1)
      end
      pwd = password.shuffle.join
    end
    return pwd
  end
end
