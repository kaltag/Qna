# frozen_string_literal: true

module VotesHelper
  def has_vote?(votable, user, voice)
    Vote.find_by(votable: votable, user: user, voice: voice) || false
  end

  def disabled_button(votable, user)
    user.nil? || user&.user_of?(votable)
  end

  def class_button(votable, user, voice)
    if has_vote?(votable, user, voice)
      'btn btn-secondary btn-sm'
    else
      'btn btn-light btn-sm'
    end
  end
end
