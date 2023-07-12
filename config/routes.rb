# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :questions do
    resources :answers, shallow: true
  end
  root to: 'questions#index'
end
