# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
  end

  trait :invalid do
    title { nil }
  end

  trait :with_file do
    files { [Rack::Test::UploadedFile.new('spec/rails_helper.rb', 'spec/spec_helper.rb')] }
  end
end
