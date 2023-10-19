# frozen_string_literal: true

require 'rails_helper'

describe 'User can mark best answer on his question', "
  In order to help find best solution
  As an authenticated user
  I'd like to be able to mark best answer to my question
" do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: other_user) }

  describe 'Authenticated user tries to mark best answer on his question', :js do
    before do
      sign_in(user)
      visit questions_path
    end

    it 'mark one answer' do
      visit question_path(question)
      # save_and_open_page
      within "div#answer_#{answers[0].id}" do
        click_on 'Mark'
      end

      within "div#answer_#{answers[0].id}" do
        expect(page).to have_content 'Best answer'
      end
      within "div#answer_#{answers[1].id}" do
        expect(page).not_to have_content 'Best answer'
      end
    end

    it 'unmark one answer' do
      visit question_path(question)

      within "div#answer_#{answers[0].id}" do
        click_on 'Mark'
        click_on 'Mark'
      end

      within "div#answer_#{answers[0].id}" do
        expect(page).not_to have_content 'Best answer'
      end
    end

    it 'mark other answer' do
      visit question_path(question)

      within "div#answer_#{answers[0].id}" do
        click_on 'Mark'
      end

      within "div#answer_#{answers[1].id}" do
        click_on 'Mark'
      end

      assert_selector 'div[id="answers"]', wait: 10

      within "div#answer_#{answers[0].id}" do
        expect(page).not_to have_content 'Best answer'
      end
      within "div#answer_#{answers[1].id}" do
        expect(page).to have_content 'Best answer'
      end
    end
  end
end
