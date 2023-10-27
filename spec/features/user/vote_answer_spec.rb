# frozen_string_literal: true

require 'rails_helper'

describe 'User can vote for an answer', "
  In order to help others find working answer
  As an authenticated user
  I'd like to be able to vote for an answer
" do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer_user) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: answer_user) }

  describe 'Authenticated user, not user' do
    before do
      sign_in(user)
      visit questions_path
    end

    it 'User vote for', :js do
      visit question_path(question)

      within '#answers' do
        click_on '↑'
      end

      within '#answers' do
        expect(page).to have_content '1'
      end
    end

    it 'User vote against', :js do
      visit question_path(question)

      within '#answers' do
        click_on '↓'
      end

      within '#answers' do
        expect(page).to have_content '-1'
      end
    end

    it 'User cancel voices for and against', :js do
      visit question_path(question)

      within '#answers' do
        click_on '↑'
        click_on '↑'
        click_on '↓'
        click_on '↓'
      end

      within '#answers' do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Authenticated user, not user' do
    before do
      sign_in(answer_user)
      visit questions_path
    end

    it 'user try to vote for/against', :js do
      visit question_path(question)

      within '#answers' do
        expect(page).not_to have_button '↑'
        expect(page).not_to have_button '↓'
      end
    end
  end

  describe 'Not authenticated user' do
    it 'User try to vote for/against', :js do
      visit question_path(question)

      within '#answers' do
        expect(page).not_to have_button '↑'
        expect(page).not_to have_button '↓'
      end
    end
  end
end
