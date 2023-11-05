# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class.new(user, question) }

  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  context 'for a visitor' do
    let!(:user) { nil }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'for the question owner' do
    let(:user) { author }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'for a different user' do
    let!(:user) { create(:user) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
