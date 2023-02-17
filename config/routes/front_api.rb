namespace :front do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: 'front/auth/sessions'
  }
  devise_scope :user do
    patch '/auth/password/update', to: 'auth/passwords#update_without_token'
  end

  get '/release_note_path', to: 'general#release_note_path', format: 'json'
  get '/version', to: 'general#version', format: 'json'
  get '/notifications', to: 'general#notifications', format: 'json'
  get '/user_info', to: 'general#user_info', format: 'json'

  get '/shops/info', to: 'shops#info', format: 'json'
  get '/shops/transaction_summary', to: 'shops#transaction_summary', format: 'json'
  get '/shops/transaction_most_sales', to: 'shops#transaction_most_sales', format: 'json'
  get '/shops/mechanic_summary', to: 'shops#mechanic_summary', format: 'json'
  get '/shops/low_stock', to: 'shops#low_stock', format: 'json'

  get '/makers/list', to: 'makers#list', format: 'json'

  get '/customers/search_checkin', to: 'customers#search_checkin', format: 'json'
  get '/customers/checkin', to: 'customers#checkin', format: 'json'
  get '/customers/checkin/:checkin_day', to: 'customers#checkin', format: 'json'
  get '/customers/histories', to: 'customers#histories', format: 'json'
  get '/customers/term', to: 'customers#term', format: 'json'
  get '/customers/suggest', to: 'customers#suggest', format: 'json'
  get '/customers/find', to: 'customers#find', format: 'json'
  get '/customers/find/:id', to: 'customers#find', format: 'json'
  post '/customers/parse_phone_number', to: 'customers#parse_phone_number', format: 'json'
  post '/customers/send_confirm_sms', to: 'customers#send_confirm_sms', format: 'json'
  post '/customers/check_phone_number', to: 'customers#check_phone_number'
  post '/customers/update_basic_info', to: 'customers#update_basic_info'
  get '/customers/request_token', to: 'customers#request_token', as: 'customer_request_token'
  post '/customers/remove_tmp_tel', to: 'customers#remove_tmp_tel'



  post '/customers/:id', to: 'customers#update', format: 'json'

  get '/checkins/list', to: 'checkins#list', format: 'json'
  get '/checkins/search_list', to: 'checkins#search_list', format: 'json'

  get '/maintenance_logs/:id', to: 'maintenance_logs#show', format: 'json'
  get '/maintenance_logs/last/:customer_id', to: 'maintenance_logs#last', format: 'json'
  post '/maintenance_logs', to: 'maintenance_logs#create', format: 'json'
  put '/maintenance_logs/:id', to: 'maintenance_logs#update', format: 'json'
  post '/maintenance_logs/list_update_price', to: 'maintenance_logs#list_update_price', format: 'json'
  get '/maintenance_logs/:id/down_payment_histories', to: 'maintenance_logs#down_payment_histories', format: 'json'
  post '/maintenance_logs/:id/down_payment_save', to: 'maintenance_logs#down_payment_save', format: 'json'
  put '/maintenance_logs/:id/down_payment_update', to: 'maintenance_logs#down_payment_update', format: 'json'
  delete '/maintenance_logs/:id/down_payment_destroy', to: 'maintenance_logs#down_payment_destroy', format: 'json'
  
  # deprecated
  # Can be used up to Android App version 1.10.0
  # As of 1.11.0, replaced by post method
  delete '/maintenance_logs/:id', to: 'maintenance_logs#destroy', format: 'json'
  post '/maintenance_logs/destroy/:id', to: 'maintenance_logs#destroy', format: 'json'
  post '/maintenance_logs/restore/:id', to: 'maintenance_logs#restore', format: 'json'
  post '/maintenance_logs/resend_whatsapp_receipt/:id', to: 'maintenance_logs#resend_whatsapp_receipt', format: 'json'
  post '/maintenance_logs/send_cost_estimation/', to: 'maintenance_logs#cost_estimation', format: 'json'

  get '/shop_products/suggest', to: 'shop_products#suggest', format: 'json'
  get '/shop_products/quicksearch', to: 'shop_products#quicksearch', format: 'json'
  get '/shop_products/history', to: 'shop_products#history', format: 'json'
  get '/shop_products/list', to: 'shop_products#list', format: 'json'
  get '/shop_products/categories', to: 'shop_products#categories', format: 'json'
  post '/shop_products', to: 'shop_products#create', format: 'json'
  post '/shop_products/update_price', to: 'shop_products#update_price', format: 'json'

  get '/customize_shop_product_lists', to: 'customize_shop_product_lists#index'
  get '/customize_shop_product_lists/:id', to: 'customize_shop_product_lists#find'
  put '/customize_shop_product_lists/update_list', to: 'customize_shop_product_lists#update_list'
  post '/customize_shop_product_lists', to: 'customize_shop_product_lists#create'
  put '/customize_shop_product_lists/:id', to: 'customize_shop_product_lists#update'
  delete '/customize_shop_product_lists/:id', to: 'customize_shop_product_lists#destroy'

  get '/notifications/list', to: 'notifications#list', format: 'json'
  get '/notifications/tags', to: 'notifications#tags', format: 'json'
end
