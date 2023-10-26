# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward do
  it { is_expected.to belong_to :question }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :file }
end
