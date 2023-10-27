# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotesController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create', :js do
    before { sign_in(user) }

    it 'saves a vote in the database', :js do
      expect do
        post :create, params: { vote: { voice: 1 }, question_id: question.id },
                      format: :turbo_stream
      end.to change(Vote, :count).by(1)
    end

    it 'delete a vote from the database', :js do
      vote = create(:vote, user: user, votable: question, voice: 1)
      expect do
        post :create, params: { vote: { voice: vote.voice }, question_id: vote.votable_id },
                      format: :turbo_stream
      end.to change(Vote, :count).by(-1)
    end

    it 'change a vote in the database', :js do
      vote = create(:vote, user: user, votable: question, voice: 1)
      post :create, params: { vote: { voice: -1 }, question_id: vote.votable_id }, format: :turbo_stream
      expect(vote.reload.voice).to eq(-1)
    end
  end
end
