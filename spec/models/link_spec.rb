# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }
  it { is_expected.to belong_to :question }
end
