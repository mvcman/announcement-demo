Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:show, :edit, :update] do 
    collection do 
      patch :update_status
    end
  end

  resources :organizations, except: :index do 
    resources :projects, module: :organizations
    resources :announcements, module: :organizations
    resources :departments, module: :organizations do 
      collection do 
        patch "update_department_user"
      end
    end
    resources :organization_employees, module: :organizations, except: :show
  end

  resource :dashboard, only: :show
  resource :registration, only: [:new, :create]
  resource :session, only: %i[new create destroy]
  resource :password_reset, only: %i[new create edit update]

  resource :invitation, only: [:update] do
    collection do
      get :accepts
    end
  end
  # Defines the root path route ("/")
  root "pages#home"
end
