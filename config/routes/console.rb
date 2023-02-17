namespace :console do

  # dashboard
  match '/dashboard', to: 'dashboard#index', as: 'dashboard_index', :via => [:get,:post]
  
  #shop_groups
  
  resources :shop_groups do
    collection do
      post 'bulk_create'
    end
  end
  

  # shops
  get '/shops/import_expiration', to: 'shops#import_expiration'
  post '/shops/import_expiration_execution', to: 'shops#import_expiration_execution'
  get '/shops/import_subscription', to: 'shops#import_subscription'
  post '/shops/import_subscription_execution', to: 'shops#import_subscription_execution'
  get '/shops/list_report', to: 'shops#export_shop_list_report'
  resources :shops

  #checkins
  resources :checkins, :only => [:index, :show]
  
  # facility
  resources :facilities

  # service
  resources :services

  # users
  resources :users, :only => [:index, :new, :create, :edit, :update, :destroy]
  get '/users/:id/password/', to: 'users#password', as: 'password'
  patch '/users/password/update', to: 'users#password_update', as: 'password_update'
  post '/users/:id/disable', to: 'users#disable_user', as: 'disable_user'
  post '/users/:id/enable', to: 'users#enable_user', as: 'enable_user'

  # shop_configs
  resources :shop_configs, :only => [:index, :edit, :update]
  post '/shop_configs/search_tags', to: 'shop_configs#search_tags'

  # shop_staffs
  resources :shop_staffs, :only => [:index, :new, :create, :edit, :update]

  # customers
  get '/customers/list', to: 'customers#list', as: 'customer_list'
  get '/customers/:id/show', to: 'customers#show', as: 'customer_show'
  get '/customers/:id/checkins', to: 'customers#checkins', as: 'customer_checkins'
  get '/customers/:id/checkin/:maintenance_log_id', to: 'customers#checkin', as: 'customer_checkin_show'
  get '/customers/:id/edit', to: 'customers#edit', as: 'customer_edit'
  patch '/customers/:id/update', to: 'customers#update', as: 'customer_update'
  get '/customers/:id/answers', to: 'customers#answers', as: 'customer_answers'
  get '/customers/export', to: 'customers#export', as: 'customers_export'
  get '/customers/import', to: 'customers#import'
  post '/customers/import_confirm', to: 'customers#import_confirm'
  post '/customers/import_execution', to: 'customers#import_execution'
  get '/customers/:id/edit_phone_number', to: 'customers#edit_phone_number', as: 'customer_edit_phone_number'
  patch '/customers/:id/update_phone_number', to: 'customers#update_phone_number', as: 'customer_update_phone_number'
  
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
  get '/admin_products/import', to: 'admin_products#import'
  post '/admin_products/import_confirm', to: 'admin_products#import_confirm'
  post '/admin_products/import_execution', to: 'admin_products#import_execution'
  get '/admin_products/template_export', to: 'admin_products#template_export'


  # shop_products
  get '/shop_products', to: 'shop_products#index'
  get '/shop_products/print', to: 'shop_products#print'
  get '/shop_products/list', to: 'shop_products#list'
  get '/shop_products/template_export', to: 'shop_products#template_export'
  get '/shop_products/import', to: 'shop_products#import'
  post '/shop_products/import_confirm', to: 'shop_products#import_confirm'
  post '/shop_products/import_execution', to: 'shop_products#import_execution'

  # suppliers
  resources 'suppliers', :only => [:index, :new, :create, :edit, :update, :destroy]

  # bikes
  get '/bikes', to: 'bikes#index'

  # export
  get '/export/list', to: 'export#list'
  get '/export/patterns', to: 'export#patterns'
  get '/export/layout/:id/show', to: 'export#layout_show', as: 'export_layout'
  get '/export/layout/:id/edit', to: 'export#layout_edit', as: 'export_layout_edit'
  patch '/export/layout/:id/update', to: 'export#layout_update', as: 'export_layout_update'
  get '/export/shop_sales_data', to: 'export#shop_sales_data', as: 'export_shop_sales_data'
  get '/export/item_master', to: 'export#item_master', as: 'export_item_master'
  get '/export/subscriptions_data', to: 'export#subscriptions_data', as: 'export_subscriptions_data'

  # makers
  patch '/makers/order_update', to: 'makers#order_update'
  resources :makers, :only => [:index, :new, :create, :edit, :update]

  # bike_models
  resources :bike_models, :only => [:index, :new, :create, :edit, :update]

  # versions
  get '/versions', to: 'versions#index'
  post '/versions/:type/require_to_latest', to: 'versions#require_to_latest', as: 'versions_require_to_latest'

  #whats app
  resources :whats_app_templates, :only => [:index, :new, :create, :edit, :update, :destroy]
  post 'update_default_template', to: 'whats_app_templates#update_default_template'
  #whats app shop
  post 'whats_app_shop_templates/shop/:id/', to: 'whats_app_templates#update_shop_default_template', as: 'whats_app_shop_templates'

  # notification
  resources :notifications, :only => [:index, :new, :create, :edit, :update, :destroy]

  # requests
  get 'requests/new_application', to: 'requests#new_application', as: 'requests_new_application'
  post 'requests/:id/update_new_application_status', to: 'requests#update_new_application_status', as: 'requests_update_new_application_status'
  get 'requests/renewal_application', to: 'requests#renewal_application', as: 'requests_renewal_application'
  post 'requests/:id/update_renewal_application_status', to: 'requests#update_renewal_application_status', as: 'requests_update_renewal_application_status'

  # subscriptions
  resources 'subscriptions', :only => [:index, :new, :create, :edit, :update, :destroy]
  get 'subscriptions/invoice', to: 'subscriptions#invoice', as: 'subscriptions_invoice'
  get 'subscriptions/invoice_report', to: 'subscriptions#export_invoice_report'

  # variant
  resources 'variants', :only => [:index, :new, :create, :edit, :update]
  post '/variants/edit_multiple', to: 'variants#edit_multiple'

  #brands
  resources :brands, :only => [:index, :new, :create, :edit, :update]
  post '/brands/edit_multiple', to: 'brands#edit_multiple'
  
  #tech_specs
  resources :tech_specs, :only => [:index, :new, :create, :edit, :update]
  post '/tech_specs/edit_multiple', to: 'tech_specs#edit_multiple'

  #payment_gateway
  get 'payment_gateway', to: 'payment_gateway#index', as: 'payment_gateway'
  get 'payment_gateway/search', to: 'payment_gateway#search_shop', as: 'payment_gateway_search_shop'
  post 'payment_gateway/update', to: 'payment_gateway#update', as: 'payment_gateway_update'

end

