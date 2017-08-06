Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: 'static#home'

  match '/logout', to: 'static#logout', via: [:get, :post]
  
  # This route is for develoment only, allows to impersonate random site user
  get 'impersonate/:email', to: 'static#impersonate', constraints: {email: /[^\/]+/} if Rails.env.development?

  scope do
    get 'me', to: 'redirect#me'
    get '/login', to: 'static#login'
    post '/login', to: 'static#login_post'
    post '/signup', to: 'static#signup'
    get '/signup', to: 'static#home'
    get 'httpsify', to: 'static#httpsify'

    resource :request_reset, only: [:show, :create],  path: '/request-reset'
    resources :validation_tokens, only: [:show, :update]
    resource :users, only: [] do
      member do
        get :change_password
        put :set_password
      end
    end
    
    [:volunteers, :applicants, :coordinators].each do |p|
      resources p do
        collection do
          match 'search', via: [:get, :post]
          get 'assignments' if p == :volunteers
        end
      end
    end

    post 'projects/search', to: 'projects#search', as: :search_projects
    resources :projects do
      resources :members, except: [:new] do
        collection do
          get 'new_volunteer'
        end
      end
      resource :openings, shallow: true
    end

    resources :openings
  end
end
