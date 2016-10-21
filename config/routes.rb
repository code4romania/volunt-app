Rails.application.routes.draw do
  root to: 'static#home'

  get '/login', to: 'static#login'
  post '/login', to: 'static#login_post'
  post '/logout', to: 'static#logout'

  resources :volunteers, only:[:show, :index] do
    collection do
      post 'search'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
