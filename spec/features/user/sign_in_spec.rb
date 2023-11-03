# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  before { visit new_user_session_path }

  describe 'Registered user tries to sign in' do
    let!(:user) { create(:user) }

    it 'with email' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    it 'with github' do
      expect(page).to have_content('Sign in with GitHub')
      mock_auth(:github, user.email)
      click_button 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from Github account.')
    end
  end

  describe 'Unregistered user tries to sign in' do
    it 'with email' do
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end

    it 'with github' do
      expect(page).to have_content('Sign in with GitHub')
      mock_auth(:github, 'test@test.com')
      click_button 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from Github account.')
    end
  end
end
