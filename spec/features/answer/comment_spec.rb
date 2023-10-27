# frozen_string_literal: true

require 'rails_helper'

feature 'User can comment an answer', "
  In order to express my opinion about
  As an authenticated user
  I'd like to be able to comment an answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'comment an answer', js: true do
      visit question_path(question)
      fill_in :comment_body, with: 'Comment'
      click_on 'Send'

      within("#answer_#{answer.id}_comments") do
        expect(page).to have_content 'Comment'
      end
    end

    scenario 'comment an answer, multiple sessions', js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
        visit question_path(question)

        fill_in :comment_body, with: 'Comment'
        click_on 'Send'

        expect(page).to have_content 'Comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment'
      end
    end
  end

  scenario 'Unauthenticated user tries to comment a answer' do
    visit question_path(question)

    expect(page).not_to have_selector 'textfield'
    expect(page).not_to have_button 'Send'
  end
end
