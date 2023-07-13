# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyTextAns' }
    question

    trait :invalid do
      body { nil }
    end
  end
end
