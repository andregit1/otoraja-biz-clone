class MigrationCognitoUserpool20200204
  def self.execute
    config = Aws::AwsUtility.config
    client = Aws::AwsUtility.CognitoIdentityProvider_client

    customers = Customer.where.not(tel: nil).where.not(tel: '')
    puts "target customer count = #{customers.count}"
    customers.each do | customer |
      puts "Customer ID=#{customer.id}"
      begin
        # 電話番号が重複しているCustomerは別対応
        if Customer.where(tel: customer.tel).count > 1
          puts "Duplicate phone number #{customer.tel}"
          next
        end

        password = password_gen
        username = SecureRandom.uuid
        if customer.cognito_id.present?
          # すでにCognitoIdが登録されている場合
          username = customer.cognito_id
          password = customer.cognito_pw
        end
        puts "Username=#{username}"
        puts "Password=#{password}"

        phone_number = "+#{customer.tel}"

        # Cognito存在チェック
        resp = client.list_users({
          user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
          filter: "phone_number = \"#{phone_number}\""
        })
        unless resp.users.length == 0
          cognito_user = resp.users.first
          puts "Duplicate Cognito username:#{cognito_user.username} #{phone_number}"
          next
        end

        # ユーザー作成
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
        # パスワード更新(本ユーザー登録)
        resp = client.admin_respond_to_auth_challenge({
          user_pool_id: config['cognito_setting']['pool_data']['user_pool'],
          client_id: config['cognito_setting']['pool_data']['client_id'],
          challenge_name: 'NEW_PASSWORD_REQUIRED',
          session: resp.session,
          challenge_responses: {
            USERNAME: username,
            NEW_PASSWORD: password,
          }
        })

        unless customer.cognito_id.present?
          customer.cognito_id = username
          customer.cognito_pw = password
          customer.save
        end
      rescue => e
        puts "migration error!"
        puts e.backtrace.join('\n')
        next
      end
    end
  end

private
  def self.password_gen(length=8)
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

MigrationCognitoUserpool20200204.execute
