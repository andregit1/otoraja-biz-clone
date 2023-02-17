# bengkel api
namespace :bengkel do
  get '/shop/list', to: 'shop#list', format: 'json'
  get '/shop/province_list', to: 'shop#province_list', format: 'json'
  get '/shop/:bengkel_id', to: 'shop#get', format: 'json'
end