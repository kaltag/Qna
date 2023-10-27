# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :gists, only: %i[show]
  resources :rewards, only: %i[index]

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
