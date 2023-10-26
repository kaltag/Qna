# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def show_votes
    Vote.votable_voices(self).pluck(:voice).reduce(:+) || 0
  end
  # Your code here...
end
