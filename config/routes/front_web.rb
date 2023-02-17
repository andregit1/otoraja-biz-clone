devise_for :users, :skip => [:registrations,:passwords], controllers: {
  sessions: 'users/sessions'
} 

devise_scope :user do
  get '/users/password/change', to: 'users/passwords#change', as: 'user_password_change'
  patch '/users/password/update_without_token', to: 'users/passwords#update_without_token'
  get "/console/sign_in" => "management_users/sessions#new_mgr", as: :new_management_session
  post "/console/sign_in" => "management_users/sessions#create_mgr", as: :management_session
  delete "/console/sign_out" => "management_users/sessions#destroy", as: :destroy_management_session
end

# front
# front route for FSA browser already deprecated and permanently close this feature
# get '/checkin', to: 'checkin#index', as: 'front_index'
# get '/checkin/uncheckout_list', to: 'checkin#uncheckout_list', as: 'front_uncheckout_list'
# get '/checkin/:checkin_day', to: 'checkin#index', as: 'front_setday'
# delete '/checkin/delete/:id', to: 'checkin#delete_checkin', as: 'front_delete_checkin'
# post '/checkin/undelete/:id', to: 'checkin#undelete_checkin', as: 'front_undelete_checkin'
# post '/checkin/checkout/:id', to: 'checkin#checkout', as: 'front_checkout'

# receipt
get '/receipt/for_stores/:checkin_id', to: 'receipt#output_for_stores', as: 'receipt_output_for_stores', format: 'pdf'
get '/receipt/:token', to: 'receipt#output_for_customer', as: 'receipt_output_for_customer', format: 'pdf'
get '/receipt/estimation/:token', to: 'receipt#output_cost_estimation_for_customer', as: 'receipt_output_cost_estimation_for_customer', format: 'pdf'
get '/receipt/downpayment/:token', to: 'receipt#output_down_payment_for_customer', as: 'receipt_output_down_payment_for_customer', format: 'pdf'

#  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'
namespace :pdf do
  get '/viewer', to: 'viewer#index', as: 'viewer'
end

# maintenance_log 
# Manetanence_log route for FSA browser already deprecated and permanently close this feature
# get '/maintenance_log/new', to: 'maintenance_log#new', as: 'new_maintenance_log'
# post '/maintenance_log/new', to: 'maintenance_log#create'
# get '/maintenance_log/:checkin_id/edit', to: 'maintenance_log#edit', as: 'edit_maintenance_log'
# patch '/maintenance_log/:checkin_id/edit', to: 'maintenance_log#update'
# delete '/maintenance_log/:checkin_id/delete', to: 'maintenance_log#destroy', as: 'destroy_maintenance_log'
# post '/maintenance_log/send_confirm_sms', to: 'maintenance_log#send_confirm_sms'
# post '/maintenance_log/:checkin_id/regist_phone', to: 'maintenance_log#resist_phone_number'
# get '/maintenance_log/:checkin_id/show', to: 'maintenance_log#show', as: 'show_maintenance_log'


# shortened url redirect
get '/s/:id', to: 'shortener/shortener#show', as: 'shortener'

# two factor auth
# todo: two factor is not working.
# resource 'two_factor_auth', only: [:index, :new, :create, :destroy]

# questionnaire
get '/questionnaire/:uuid', to: 'questionnaire#index', as: 'questionnaire'
post '/questionnaire/:uuid/create', to: 'questionnaire#create', as: 'questionnaire_create'
post '/questionnaire/:uuid/save', to: 'questionnaire#save'
get '/administrative_areas/districs', to: 'administrative_areas#districs'

resources :change_phone_number_verification, only: [:show], param: :uuid
# new contract requests
resources :register, only: [:new,:create]