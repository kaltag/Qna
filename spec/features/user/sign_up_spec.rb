# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign up', "
  In order to have an account
  As an not registered user
  I'd like to be able to sign up
" do
  it 'Not registered user tries to sign up' do
    visit questions_path
    click_on 'Sign up'
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: '123321'
    fill_in 'Password confirmation', with: '123321'
    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end

  it 'Registered user tries to sign up' do
    user = create(:user)
    visit questions_path
    click_on 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
