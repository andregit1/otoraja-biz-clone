namespace :admin do
  # dashboard
  match '/dashboard', to: 'dashboard#index', as: 'dashboard_index', :via => [:get,:post]
  patch '/dashboard/initial_setup', to: 'dashboard#update_initial_setup', as: 'dashboard_initial_setup'

  # shops
  get '/shops', to: 'shops#index'
  get '/shops/:scope', to: 'shops#index', as: 'shops_scope'
  get '/shops/:id/show', to: 'shops#show', as: 'shops_show'
  post '/shops/default_session_shop', to: 'shops#default_session_shop', as: 'default_session_shop'

  # users
  resources :users, :only => [:index, :new, :create, :edit, :update, :show, :destroy]
  get '/users/:id/password/', to: 'users#password', as: 'password'
  patch '/users/password/update', to: 'users#password_update', as: 'password_update'
  post '/users/:id/disable', to: 'users#disable_user', as: 'disable_user'
  post '/users/:id/enable', to: 'users#enable_user', as: 'enable_user'

  # checkins
  get '/checkins/list', to: 'checkins#list', as: 'checkin_list'
  get '/checkins/:id/show', to: 'checkins#show', as: 'checkin_show'
  get '/checkins/download', to: 'checkins#export_transaction_list'

  # shop_configs
  resources :shop_configs, :only => [:index, :edit, :update]

  # shop_staffs
  resources :shop_staffs, :only => [:index, :new, :create, :edit, :update]

  # customers
  get '/customers/list', to: 'customers#list', as: 'customer_list'
  get '/customers/:id/show', to: 'customers#show', as: 'customer_show'
  get '/customers/:id/edit_basic_info', to: 'customers#edit_basic_info', as: 'customer_edit_basic_info'
  get '/customers/:id/checkins', to: 'customers#checkins', as: 'customer_checkins'
  get '/customers/:id/checkin/:maintenance_log_id', to: 'customers#checkin', as: 'customer_checkin_show'
  get '/customers/:id/edit', to: 'customers#edit', as: 'customer_edit'
  patch '/customers/:id/update', to: 'customers#update', as: 'customer_update'
  patch '/customers/:id/update_basic_info', to: 'customers#update_basic_info', as: 'customer_update_basic_info'
  get '/customers/:id/answers', to: 'customers#answers', as: 'customer_answers'
  get '/customers/export', to: 'customers#export', as: 'customers_export'
  get '/customers/request_token', to: 'customers#request_token', as: 'customer_request_token'
  get '/customers/check_phone_number', to: 'customers#check_phone_number', as: 'customer_check_phone_number'
  get '/customers/remove_tmp_tel', to: 'customers#remove_tmp_tel', as: 'customer_remove_temp_tel'

  
  # answer
  match '/answer', to: 'answer#index', :via => [:get,:post], as: 'answers'
  get '/answer/:id', to: 'answer#show', as: 'answer'
  get '/export/answer', to: 'answer#export'

  # stock
  match '/stock', to: 'stock#index', :via => [:get,:post]
  get '/stock/:id/show', to: 'stock#show'
  get '/stock/shop/:id/suppliers', to: 'stock#suppliers'
  post '/stock/update', to: 'stock#update'
  get '/stock/:id/stock_controll', to: 'stock#stock_controll'
  post '/stock/edit', to: 'stock#edit'
  
  # product_categories
  resources :product_categories, :only => [:index, :new, :create, :edit, :update, :destroy]

  # admin_products
  get '/admin_products', to: 'admin_products#index'

  # shop_products
  get '/shop_products', to: 'shop_products#index'
  get '/shop_products/print', to: 'shop_products#print'

  # shop_expenses
  get '/shop_expenses/download', to: 'shop_expenses#export_expenses_report'
  post '/shop_expenses/create_supplier', to: 'shop_expenses#create_supplier'
  resources 'shop_expenses'


  # suppliers
  resources 'suppliers', :only => [:index, :new, :create, :edit, :update, :destroy]

  # bikes
  get '/bikes', to: 'bikes#index'
  get '/bikes/:id/edit', to: 'bikes#edit', as: 'bike_edit'
  patch '/bikes/:id/update', to: 'bikes#update', as: 'bike_update'
  patch '/bikes/:id/update_confirm', to: 'bikes#update_confirm', as: 'bike_update_confirm'
  delete '/bikes/:id', to: 'bikes#destroy', as: 'bike_destroy'

  # export
  get '/export/list', to: 'export#list'
  get '/export/patterns', to: 'export#patterns'
  get '/export/layout/:id/show', to: 'export#layout_show', as: 'export_layout'
  get '/export/layout/:id/edit', to: 'export#layout_edit', as: 'export_layout_edit'
  patch '/export/layout/:id/update', to: 'export#layout_update', as: 'export_layout_update'

  # packaging product relations
  resources :packaging_product_relations, :only => [:index, :new, :create, :edit, :update]

  #notification
  get '/notifications', to: 'notifications#index'
  get '/notifications/:id/show', to: 'notifications#show', as: 'notifications_show'

  # shop invoices
  get '/shop_invoices', to: 'shop_invoices#index'
  get '/shop_invoices/:id/show', to: 'shop_purchases#show'
  get '/shop_invoices/:id/edit', to: 'shop_purchases#edit'

  # shop purchases
  get '/shop_purchases', to: 'shop_purchases#index'

  # sales details
  match '/sales_details', to: 'sales_details#index', as: 'sales_details_index', :via => [:get,:post]

  # subscriptions
  resources 'subscriptions', :only => [:index, :new, :create, :edit, :update, :destroy]
  get '/subscriptions/:id/show', to: 'subscriptions#show', as: 'subscriptions_show'
  get '/subscriptions/:id/detail', to: 'subscriptions#new', as: 'subscriptions_new'
  get '/subscriptions/:id/payment', to: 'subscriptions#payment', as: 'subscriptions_payment'
  get '/subscriptions/:id/payment_proof', to: 'subscriptions#payment_proof', as: 'subscriptions_payment_proof'
  get '/subscriptions/:id/payment_receipt', to: 'subscriptions#payment_receipt', as: 'subscriptions_payment_receipt'
  get '/subscriptions/subscription_details', to: 'subscriptions#detail', as: 'subscriptions_details'
  post '/subscriptions/change_plan', to: 'subscriptions#change_plan', as: 'subscriptions_change_plan'
  patch '/subscriptions/:id/upload_payment', to: 'subscriptions#upload_payment', as: 'subscriptions_upload_payment'

  # shop_accounts
  get '/shop_accounts', to: 'shop_accounts#index'

  # subscription plan
  resources 'subscription_plan', :only => [:index, :new, :create, :edit, :update, :destroy]
  match '/subscription_plan/show', to: 'subscription_plan#show', as: 'subscription_plan_show', :via => [:get, :post]
  get '/subscription_plan/:shop_id/new', to: 'subscription_plan#new', as: 'subscription_plan_new'
  get '/subscription_plan/:shop_id/change_plan', to: 'subscription_plan#change_plan', as: 'subscription_change_plan'
  get '/subscription_plan/payment_method_check', to: 'subscription_plan#payment_method_check', as: 'subscription_plan_payment_method_check'
  get '/subscription_plan/download_qrcode', to: 'subscription_plan#download_qrcode', as: 'subscription_plan_download_qrcode'
  post '/subscription_plan/continue_payment', to: 'subscription_plan#continue_payment', as: 'subscription_plan_continue_payment'
  post '/subscription_plan/status_subscription_check', to: 'subscription_plan#status_subscription_check', as: 'status_subscription_check'

  # stock_book_report
  get '/stock_book_report', to: 'stock_book_reports#index'
  get '/stock_book_report/download', to: 'stock_book_reports#export_stock_book_report'

  #low_stock_report
  get '/low_stock_report', to: 'low_stock_report#index'

  #Shop Setting
  get '/shop_setting', to: 'shop_setting#index'
  get '/shop_setting/new_branch', to: 'shop_setting#new_branch'
  get '/shop_setting/edit_owner', to: 'shop_setting#edit_owner'
  get '/shop_setting/:shop_id/edit_branch', to: 'shop_setting#edit_branch', as: 'shop_setting_edit_branch'
  post '/shop_setting/create_branch', to: 'shop_setting#create_branch'
  delete '/shop_setting/delete_logo', to: 'shop_setting#delete_logo'

  patch '/shop_setting/update_owner', to: 'shop_setting#update_owner'
  patch '/shop_setting/update_password', to: 'shop_setting#update_password'
  patch '/shop_setting/:shop_id/update_branch', to: 'shop_setting#update_branch', as: 'shop_setting_update_branch'

  #product non-active
  get '/product_non_active', to: 'product_non_active#index'

  #mechanic report
  get '/mechanic_reports', to: 'mechanic_reports#index'

  if Rails.env.development? || Rails.env.staging?
    get '/style_guideline', to: 'style_guideline#index'
  end
end

#subscription receipts 
get '/receipt/subscription/public/:token', to: 'receipt#output_for_subscriptions_public', as: 'receipt_output_for_subscriptions_public', format: 'pdf'
get '/receipt/subscription/:subscription_id', to: 'receipt#output_for_subscriptions', as: 'receipt_output_for_subscriptions', format: 'pdf'