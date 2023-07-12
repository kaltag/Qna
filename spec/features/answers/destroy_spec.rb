# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete own answer' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  let(:user_2) { create(:user) }

  describe 'Authenticated user' do
    it 'can delete own answer' do
      sign_in(user)

      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to have_content question.title
      expect(page).not_to have_content answer.body
    end

    it 'tries to delete someone else answer' do
      sign_in(user_2)

      visit question_path(question)

      expect(page).not_to have_content 'Delete answer'
    end
  end

  it 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end
end
