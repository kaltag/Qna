# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vote

  def create
    @vote ||= @votable.votes.build(vote_params)
    @vote.extra_data = vote_params
    @vote.save_or_update
  end

  def update; end

  private

  def set_vote
    @votable = votable
    @vote = Vote.find_by(user: current_user, votable: @votable)
  end

  def vote_params
    params.require(:vote).permit(:voice).merge(user: current_user)
  end

  def votable
    params.each_key do |key|
      match = key.match(/(.+)_id\z/)
      if match
        votable_type = key.match(/(.+)_id/)[1]
        return votable_type.classify.constantize.find(params[key])
      end
    end
  end
end
