# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete his questions', "
  In order to any reason
  As an userised user
  I'd like to be able to delete my questions
" do
  let(:users) { create_list(:user, 2) }
  let!(:question_1) { create(:question, user: users[0]) }
  let!(:question_2) { create(:question, user: users[1]) }

  describe 'Authenticated user' do
    before do
      sign_in(users[0])
    end

    it 'tries to delete his question' do
      visit question_path(question_1)
      click_on 'Delete question'

      expect(page).to have_content 'Question was successfully deleted'
    end

    it 'tries to delete not his question' do
      visit question_path(question_2)

      expect(page).not_to have_button 'Delete question'
    end
  end

  describe 'Unauthenticated user' do
    it 'tries to delete any question' do
      visit question_path(question_1)

      expect(page).not_to have_button 'Delete question'
    end
  end
end
