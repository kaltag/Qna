# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestJob do
  let(:daily_digest_service) { double(DailyDigestService) }

  before do
    allow(DailyDigestService).to receive(:new).and_return(daily_digest_service)
    allow(daily_digest_service).to receive(:send_digest).and_return(daily_digest_service)
  end

  it 'calls DailyDigestService#send_digest' do
    subject.perform

    expect(daily_digest_service).to have_received(:send_digest)
  end
end
