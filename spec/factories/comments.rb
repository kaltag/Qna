# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user
    body { 'Comment' }
  end
end
