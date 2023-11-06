# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :subscriptable, polymorphic: true
  belongs_to :subscriber, class_name: 'User'

  validates :subscriber, uniqueness: { scope: %i[subscriptable_type subscriptable_id] }
end
