# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  let!(:user) { create(:user, confirmation_token: '123') }

  describe 'GET #confirm_email' do
    it 'renders an email form' do
      get :confirm_email_new, params: { id: user.id }
      expect(response).to render_template('users/confirm_email_new')
    end
  end

  describe 'POST #confirm_email' do
    context 'new user' do
      # before { post :confirm_email_create, params: { id: user.id, email: 'new_email@mal.com' } }

      it 'updates user email' do
        post :confirm_email_create, params: { id: user.id, email: 'new_email@mal.com' }

        expect(user.reload.email).to eq('new_email@mal.com')
      end

      it 'sends a confirmation email' do
        mailer = double(AuthMailer)
        allow(AuthMailer).to receive(:with).and_return(mailer)
        allow(mailer).to receive(:confirm_email).and_return(mailer)
        allow(mailer).to receive(:deliver_now)

        post :confirm_email_create, params: { id: user.id, email: 'new_email@mal.com' }

        expect(AuthMailer).to have_received(:with).with(user: user)
        expect(mailer).to have_received(:confirm_email)
        expect(mailer).to have_received(:deliver_now)
      end

      it 'renders waiting page' do
        post :confirm_email_create, params: { id: user.id, email: 'new_email@mal.com' }

        expect(response).to render_template('users/confirm_email_create')
      end
    end

    context 'user with email already exists' do
      let!(:user_other) { create(:user) }

      it 'not update user email' do
        post :confirm_email_create, params: { id: user.id, email: user_other.email }

        expect(user.reload.email).not_to eq(user_other.email)
      end

      it 'does not send a confirmation email' do
        mailer = double(AuthMailer)
        allow(AuthMailer).to receive(:with).and_return(mailer)
        allow(mailer).to receive(:confirm_email).and_return(mailer)
        allow(mailer).to receive(:deliver_now)

        post :confirm_email_create, params: { id: user.id, email: user_other.email }

        expect(AuthMailer).not_to have_received(:with).with(user: user)
        expect(mailer).not_to have_received(:confirm_email)
        expect(mailer).not_to have_received(:deliver_now)
      end

      it 're-render confirm_email_new' do
        post :confirm_email_create, params: { id: user.id, email: user_other.email }

        expect(response).to render_template('users/confirm_email_new')
      end
    end
  end

  describe 'GET #confirm_email/:token' do
    context 'user with token exists' do
      before { post :confirm_email, params: { token: '123' } }

      it 'resets user confirm_token' do
        expect(user.reload.confirmation_token).not_to be
      end

      it 'logins user' do
        expect(user).to eq controller.current_user
      end
    end

    context 'user with token does not exists' do
      it 'redirects to root_path' do
        post :confirm_email, params: { token: '234' }

        expect(response).to redirect_to root_path
      end
    end
  end
end
