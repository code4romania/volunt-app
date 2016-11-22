Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: 'static#home'

  match '/logout', to: 'static#logout', via: [:get, :post]
  
  # This route is for develoment only, allows to impersonate random site user
  get 'impersonate/:email', to: 'static#impersonate', constraints: {email: /[^\/]+/} if Rails.env.development?

  scope protocol: 'https' do
    get 'me', to: 'redirect#me'
    get '/login', to: 'static#login'
    post '/login', to: 'static#login_post'
    post '/signup', to: 'static#signup'
    get 'httpsify', to: 'static#httpsify'

    resource :request_reset, only: [:show, :create],  path: '/request-reset'
    resources :validation_tokens, only: [:show, :update]
    
    # top level status-reports must precede the nested routes
    # otherwise the nested routes hijack the collection methods
    resources :status_reports,
        except: [:new, :create],
        path: 'status-reports' do
      collection do
        get 'my', to: 'status_reports#my'
        get 'my/edit', to: 'status_reports#my_edit'
        post 'my/edit', to: 'status_reports#my_edit_post'
      end
    end
    
    [:volunteers, :fellows, :applicants, :coordinators].each do |p|
      resources p do
        collection do
          match 'search', via: [:get, :post]
          get 'assignments' if p == :volunteers
        end
        if p == :fellows
          resources :status_reports, shallow: true, path: 'status-reports' if p == :fellows
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
      resources :status_reports, shallow: true, path: 'status-reports'
      resource :openings, shallow: true
    end

    resources :openings
    # resources :templates

  end

end
