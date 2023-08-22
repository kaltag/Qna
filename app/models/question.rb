# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many_attached :files
  has_many :links, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
end
