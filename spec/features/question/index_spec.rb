# frozen_string_literal: true

require 'rails_helper'

describe 'User can view the question`s list`', "
  In order to find a similar question
  As an any user
  I'd like to be able to view the question`s list
" do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user) }

  it 'Authenticated user tries to view list of questions' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content questions[0].body
    expect(page).to have_content questions[1].body
  end

  it 'Unauthenticated user tries to view list of questions' do
    visit questions_path

    expect(page).to have_content questions[0].body
    expect(page).to have_content questions[1].body
  end
end
