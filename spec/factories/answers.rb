# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyTextAns' }
    question

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { [Rack::Test::UploadedFile.new('spec/rails_helper.rb', 'spec/spec_helper.rb')] }
    end
  end
end
