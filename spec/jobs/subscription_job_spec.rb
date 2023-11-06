# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionJob do
  let(:subscription_service) { double(SubscriptionService) }
  let(:answer) { double(Answer) }

  before do
    allow(SubscriptionService).to receive(:new).and_return(subscription_service)
    allow(subscription_service).to receive(:send_update_with).and_return(subscription_service)
  end

  it 'calls SubscriptionService#send_update_with' do
    subject.perform(answer)

    expect(subscription_service).to have_received(:send_update_with)
  end
end
