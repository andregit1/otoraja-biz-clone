namespace :callback do
  post '/transaction_log/update_status', to: 'transaction_log#update_status', format: 'json'
end