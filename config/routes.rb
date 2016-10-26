Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: 'static#home'

  get '/login', to: 'static#login'
  post '/login', to: 'static#login_post'
  match '/logout', to: 'static#logout', via: [:get, :post]

  resource :request_reset, only: [:show, :create], protocol: 'https', path: '/request-reset'
  resources :validation_tokens, only: [:show, :update], protocol: 'https'

  [:volunteers, :fellows, :applicants, :coordinators].each do |p|
    resources p do
      collection do
        match 'search', via: [:get, :post]
      end
    end
  end

  resources :projects do
    resources :members, except: [:new] do
      collection do
        get 'new_volunteer'
        get 'new_fellow'
      end
    end
  end
  

  resources :templates

end
