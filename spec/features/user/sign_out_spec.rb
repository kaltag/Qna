# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign out', "
  In order to any reason
  As an authenticated user
  I'd like to be able to sign out
" do
  let(:user) { create(:user) }

  before { sign_in(user) }

  it 'Authenticated user tries to sign out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
