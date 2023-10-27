# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :gists, only: %i[show]
  resources :rewards, only: %i[index]
  concern :votable do
    resources :votes
  end

  resources :links, only: [], param: :index do
    member do
      post '/' => 'links#create'
      delete '(:id)' => 'links#destroy'
    end
  end

  resources :questions, concerns: :votable, only: %i[index show new create destroy update edit] do
    resources :answers, concerns: :votable, only: %i[new create destroy update edit], shallow: true do
      member do
        post :mark
      end
    end
  end
end
