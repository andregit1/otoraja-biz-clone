root to: 'home#index'

# health check
get '/health_check', to: 'health_check#index'
#register
get '/register', to: 'register#new'
patch '/register', to: 'register#create'
get '/register/thank_you', to: 'register#thank_you'