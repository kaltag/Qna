# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many_attached :files

  validates :body, presence: true
end
