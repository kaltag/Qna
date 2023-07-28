# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :questions do
    resources :answers, shallow: true do
      member do
        post :mark
      end
    end
  end
  delete 'attachments/:id/purge', to: 'attachments#purge', as: 'purge_attachment'
  root to: 'questions#index'
end
