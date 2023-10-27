# frozen_string_literal: true

require 'rails_helper'

feature 'User can comment a question', "
  In order to express my opinion about
  As an authenticated user
  I'd like to be able to comment a question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'comment a question', js: true do
      visit questions_path
      fill_in :comment_body, with: 'Comment'
      click_on 'Send'

      within("#question_#{question.id}_comments") do
        expect(page).to have_content 'Comment'
      end
    end

    scenario 'comment a question, multiple sessions', js: true do
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
        visit questions_path

        fill_in :comment_body, with: 'Comment'
        click_on 'Send'

        expect(page).to have_content 'Comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment'
      end
    end
  end

  scenario 'Unauthenticated user tries to comment a question' do
    visit questions_path

    expect(page).not_to have_selector 'textfield'
    expect(page).not_to have_button 'Send'
  end
end
