# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign in' do
  let(:user) { create(:user) }

  before { sign_in(user) }

  it 'User sign out' do
    click_on 'Выйти'

    expect(page).to have_content 'Войти'
  end
end
