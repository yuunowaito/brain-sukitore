Rails.application.routes.draw do
  get "privacy_policy", to: "pages#privacy_policy"
  get "terms_of_service", to: "pages#terms_of_service"
  resources :games, only: [ :show ] do
    member do
      get :play
    end
    collection do
      post :answer
      get  :result
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    get  "users/auth/line/email_setup",
         to: "users/omniauth_callbacks#line_email_setup",
         as: :line_email_setup
    post "users/auth/line/complete",
         to: "users/omniauth_callbacks#line_complete",
         as: :line_complete
  end
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
