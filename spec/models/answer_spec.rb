# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer do
  it { is_expected.to validate_presence_of :body }

  describe 'associations' do
    it { is_expected.to belong_to(:question).class_name('Question') }
    it { is_expected.to belong_to(:user).class_name('User') }
  end

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
