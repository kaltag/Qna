# frozen_string_literal: true

require 'rails_helper'

describe 'User can create answers' do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit questions_path
      visit question_path(question)
    end

    it 'create an answer' do
      fill_in 'Body', with: 'Answer 1'
      click_on 'Create'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer 1'
    end
  end

  it 'Unauthenticated user tries to create an answer' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
