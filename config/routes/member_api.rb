  # mypage api
  namespace :member do

    # answers
    post '/answer/create/:uuid', to: 'answers#create', format: 'json'
    get '/answer_choice/list/:checkin_id', to: 'answers#list', format: 'json'

    # checkins
    get '/checkin/list', to: 'checkins#list', format: 'json'

    # customers
    get '/info', to: 'customers#info', format: 'json'
    put '/customer_update', to: 'customers#update', format: 'json'
    post '/save_settings', to: 'customers#save_settings', format: 'json'
    put '/customer/term/update', to: 'customers#update_mypage_terms_agreed_at', format: 'json'

    # get_change_tel
    get '/customer/get_change_tel/:uuid', to: 'customers#get_change_tel', format: 'json'

    # update_tel
    put '/update_tel/:id', to: 'customers#update_tel', format: 'json'

    # maintenance_logs
    get '/maintenance_log/:maintenance_log_id', to: 'maintenance_logs#show', format: 'json'

    # maintenance_log_details
    get '/item', to: 'maintenance_log_details#list', format: 'json'

    # makers
    get '/maker', to: 'makers#list', format: 'json'

    # owned_bikes
    get '/owned_bike/:bike_id', to: 'owned_bikes#show', format: 'json'
    put '/owned_bike/:bike_id/owned_bike_update', to: 'owned_bikes#update', format: 'json'

    # terms
    get '/term', to: 'terms#index', format: 'json'

    # tokens
    get '/token/:checkin_id/show', to: 'tokens#show', format: 'json'

    # create_email_token
    post '/create_email_token', to: 'tokens#create_token_email', format: 'json'

    # create_confirm_sms_token
    post '/create_confirm_sms_token/:uuid', to: 'tokens#create_confirm_sms_token', format: 'json'

    # create_sms_token_for_primary
    post '/create_sms_token_for_primary', to: 'tokens#create_sms_token_for_primary', format: 'json'

    # update_expired_at
    put '/update_expired_at/:uuid', to: 'tokens#update_expired_at', format: 'json'

    # send_email
    post '/send_email', to: 'tokens#send_email', format: 'json'

    # update_email
    put '/update_email/:id', to: 'customers#update_email', format: 'json'

    # get_change_mail
    get '/customer/get_change_mail/:uuid', to: 'customers#get_change_mail', format: 'json'

  end
