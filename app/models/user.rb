# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, class_name: 'Question', dependent: :destroy, inverse_of: :user
  has_many :answers, class_name: 'Answer', dependent: :destroy, inverse_of: :user
  has_many :votes, dependent: :destroy

  scope :all_rewards, ->(user) { Reward.joins(question: :answers).where(answers: { mark: true, user: user }) }

  def user_of?(post)
    post.user == self
  end

  def rewards
    User.all_rewards(self)
  end
end
