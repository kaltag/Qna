# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete own question' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:user_2) { create(:user) }
  let(:question_2) { create(:question, user: user_2) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    it 'can delete own question' do
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    it 'tries to delete someone else`s question' do
      visit question_path(question_2)

      expect(page).not_to have_content 'Delete question'
    end
  end

  it 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete question'
  end
end
