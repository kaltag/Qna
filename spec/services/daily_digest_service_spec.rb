# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }
  let(:questions) { create_list(:question, 2, user: users[0]) }

  it 'sends daily digest to all users' do
    mailer = double(DailyDigestMailer)
    users.each do |user|
      allow(DailyDigestMailer).to receive(:digest).with(user, questions).and_return(mailer)
    end
    allow(mailer).to receive(:deliver_later)

    subject.send_digest

    users.each { |user| expect(DailyDigestMailer).to have_received(:digest).with(user, questions) }
  end
end
