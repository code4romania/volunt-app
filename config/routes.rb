Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  root to: 'static#home'

  get 'me', to: 'redirect#me'

  [:volunteers, :hrs, :coordinators, :admins].each do |p|
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
