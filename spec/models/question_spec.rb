# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  describe 'associations' do
    it { is_expected.to have_many(:answers).class_name('Answer') }
    it { is_expected.to belong_to(:user).class_name('User') }
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
