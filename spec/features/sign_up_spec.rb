# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign in' do
  before { visit new_user_registration_path }

  it 'Registered user tries to sign up' do
    fill_in 'Email', with: 'Test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'
  end

  it 'user tries to sign up with invalid dates' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
