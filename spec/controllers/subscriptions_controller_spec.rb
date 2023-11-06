# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController do
  let!(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  before { login(user) }

  describe 'POST #create', :js do
    it 'creates new subscription' do
      expect do
        post :create,
             params: { subscription: { subscriptable_type: question.class, subscriptable_id: question.id }, format: :turbo_stream }
      end.to change(Subscription.all, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, subscriber: user, subscriptable: question) }

    it 'delete subscription' do
      expect do
        delete :destroy, params: { id: subscription, format: :turbo_stream }
      end.to change(Subscription.all, :count).by(-1)
    end
  end
end
