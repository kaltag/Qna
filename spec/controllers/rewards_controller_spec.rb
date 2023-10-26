# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController do
  let!(:question) { create(:question, user: create(:user)) }
  let!(:reward) { create(:reward, question: question) }
  let!(:answer_user) { create(:user) }
  let!(:answer) { create(:answer, user: answer_user, question: question, mark: true) }

  describe 'GET #index' do
    before do
      login(answer_user)
      get :index
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
