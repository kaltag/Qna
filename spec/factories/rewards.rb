# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    name { 'Reward name' }
    after(:build) do |reward|
      reward.file.attach(io: Rails.root.join('spec/fixtures/star.png').open, filename: 'star.png',
                         content_type: 'image/png')
    end
  end
end
