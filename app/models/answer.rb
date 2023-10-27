# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  after_create_commit lambda {
                        broadcast_append_to 'answers', partial: 'answers/answer_broadcast', locals: { answer: self },
                                                       target: 'answers'
                      }

  belongs_to :question
  belongs_to :user, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true, length: { minimum: 10 }
end
