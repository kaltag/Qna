# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorization do
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_presence_of :uid }
end
