# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

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
