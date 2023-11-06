# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :others, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  resources :subscriptions, only: %i[create destroy]
  resources :gists, only: %i[show]
  resources :rewards, only: %i[index]
  resources :users, only: %i[edit update show] do
    member do
      get '/confirm_email', to: 'users#confirm_email_new', as: 'confirm_email_new'
      post '/confirm_email', to: 'users#confirm_email_create', as: 'confirm_email'
    end
  end

  get '/confirm_email/:token', to: 'users#confirm_email', as: 'confirm_email_token'

  concern :votable do
    resources :votes
  end

  concern :commentable do
    resources :comments
  end

  resources :links, only: [], param: :index do
    member do
      post '/' => 'links#create'
      delete '(:id)' => 'links#destroy'
    end
  end

  resources :questions, concerns: %i[votable commentable], only: %i[index show new create destroy update edit] do
    resources :answers, concerns: %i[votable commentable], only: %i[new create destroy update edit show],
                        shallow: true do
      member do
        post :mark
      end
    end
  end
end
