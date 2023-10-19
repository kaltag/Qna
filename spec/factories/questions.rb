# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "MyTitle#{n}"
  end

  sequence :body do |n|
    "MyBody#{n}"
  end

  factory :question do
    user_id factory: %i[user]

    title
    body

    transient do
      with_attachment { false }
    end

    after(:build) do |question, evaluator|
      if evaluator.with_attachment
        question.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb').to_s), filename: 'rails_helper.rb')
      end
    end
  end

  trait :invalid do
    title { nil }
  end
end
