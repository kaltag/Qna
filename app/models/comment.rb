class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  after_create_commit lambda {
    broadcast_append_to "#{commentable_type.underscore}_#{commentable_id}_comments",
                        partial: 'comments/comment',
                        locals: { comment: self },
                        target: "#{commentable_type.underscore}_#{commentable_id}_comments"
  }
end