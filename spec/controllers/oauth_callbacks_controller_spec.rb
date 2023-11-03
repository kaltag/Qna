# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  shared_examples 'oauth provider callback' do |provider|
    let(:oauth_data) { { 'provider' => provider, 'uid' => 123 } }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)

      @authorization_service = instance_double(AuthorizationService)
      allow(AuthorizationService).to receive(:new).with(oauth_data).and_return(@authorization_service)
    end

    it 'calls method to find user' do
      expect(@authorization_service).to receive(:call)
      get provider.to_sym
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(@authorization_service).to receive(:call).and_return(user)
        get provider.to_sym
      end

      it 'logs in user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user exists wo confirmed email' do
      let!(:user) { create(:user, confirmation_token: '123') }

      before do
        allow(@authorization_service).to receive(:call).and_return(user)
        get provider.to_sym
      end

      it 'does not log in user' do
        expect(subject.current_user).not_to be
      end

      it 'redirects to email confirmation path' do
        expect(response).to redirect_to confirm_email_new_user_path(user)
      end
    end

    context 'user does not exist' do
      before do
        allow(@authorization_service).to receive(:call)
        get provider.to_sym
      end

      it 'does not log in user' do
        expect(subject.current_user).not_to be
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'Github' do
    include_examples 'oauth provider callback', 'github'
  end

  describe 'Vkontakte' do
    include_examples 'oauth provider callback', 'vkontakte'
  end
end
