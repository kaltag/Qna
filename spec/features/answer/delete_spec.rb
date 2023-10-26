# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete his answers', "
  In order to any reason
  As an userised user
  I'd like to be able to delete my answers
" do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users[0]) }

  describe 'Authenticated user', :js do
    before do
      sign_in(users[0])
      visit questions_path
    end

    it 'tries to delete his answer' do
      answer = create(:answer, question: question, user: users[0])
      visit question_path(question)

      within '#answers' do
        click_on 'Delete'
      end

      expect(page).not_to have_content answer.body
      expect(page).to have_content 'Answer was successfully deleted'
    end

    it 'tries to delete not his answer' do
      create(:answer, question: question, user: users[1])
      visit question_path(question)

      within '#answers' do
        expect(page).not_to have_button 'Delete'
      end
    end
  end

  describe 'Unauthenticated user', :js do
    it 'tries to delete any question' do
      create(:answer, question: question, user: users[0])
      visit question_path(question)
      within '#answers' do
        expect(page).not_to have_button 'Delete'
      end
    end
  end
end
