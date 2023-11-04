# frozen_string_literal: true

require 'rails_helper'

describe 'User can comment a question', "
  In order to express my opinion about
  As an authenticated user
  I'd like to be able to comment a question
" do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit questions_path
    end

    it 'comment a question', :js do
      visit questions_path
      fill_in :comment_body, with: 'Comment'
      click_on 'Send'

      within("#question_#{question.id}_comments") do
        expect(page).to have_content 'Comment'
      end
    end

    it 'comment a question, multiple sessions', :js do
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

  it 'Unauthenticated user tries to comment a question' do
    visit questions_path

    expect(page).not_to have_css 'textfield'
    expect(page).not_to have_button 'Send'
  end
end
