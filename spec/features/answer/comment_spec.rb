# frozen_string_literal: true

require 'rails_helper'

describe 'User can comment an answer', "
  In order to express my opinion about
  As an authenticated user
  I'd like to be able to comment an answer
" do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit questions_path
    end

    it 'comment an answer', :js do
      visit question_path(question)
      fill_in :comment_body, with: 'Comment'
      click_on 'Send'

      within("#answer_#{answer.id}_comments") do
        expect(page).to have_content 'Comment'
      end
    end

    it 'comment an answer, multiple sessions', :js do
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

  it 'Unauthenticated user tries to comment a answer' do
    visit question_path(question)

    expect(page).not_to have_css 'textfield'
    expect(page).not_to have_button 'Send'
  end
end
