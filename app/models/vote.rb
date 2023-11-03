# frozen_string_literal: true

class Vote < ApplicationRecord
  attr_accessor :extra_data

  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :voice, uniqueness: { scope: %i[user_id votable_type votable_id] }

  scope :votable_voices, ->(votable) { where(votable: votable) }

  def save_or_update
    if persisted?
      if voice == extra_data[:voice].to_i
        destroy
      else
        update(extra_data)
      end
    else
      save
    end
  end
end
