# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorizationService do
  subject { described_class.new(auth) }

  let!(:user) { create(:user) }
  let(:auth_params) { { provider: 'github', uid: '123456' } }
  let(:auth) { OmniAuth::AuthHash.new(auth_params) }

  context 'user already has authorization' do
    it 'returns the user' do
      user.authorizations.create(auth_params)
      expect(subject.call).to eq user
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }

      it 'does not create new user' do
        expect { subject.call }.not_to change(User, :count)
      end

      it 'creates authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        subject.call
        expect(user.authorizations.first.provider).to eq 'github'
        expect(user.authorizations.first.uid).to eq '123456'
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'user@mail.com' }) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a User
      end

      it 'fills user email' do
        expect(subject.call.email).to eq 'user@mail.com'
      end

      it 'creates authorization for user' do
        expect(subject.call.authorizations.count).to eq 1
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first
        expect(authorization.provider).to eq 'github'
        expect(authorization.uid).to eq '123456'
      end
    end
  end
end
