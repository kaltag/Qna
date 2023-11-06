# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionService do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:subscription) { create(:subscription, subscriber: user, subscriptable: question) }
  let(:object) { create(:answer, question: question, user: user) }

  it 'sends update to subscribers' do
    mailer = double(QuestionUpdateMailer)
    allow(QuestionUpdateMailer).to receive(:send_updates).with(user, object).and_return(mailer)
    allow(mailer).to receive(:deliver_later)

    subject.send_update_with(object)

    expect(QuestionUpdateMailer).to have_received(:send_updates).with(user, object)
  end
end
