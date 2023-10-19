# frozen_string_literal: true

require 'rails_helper'

describe 'User can create answer', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to create answer on the same page
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'Authenticated user tries to answer the question', :js do
    before do
      sign_in(user)

      visit question_path(question)
    end

    it 'answer the question' do
      fill_in 'Body', with: 'Test answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
    end

    it 'answer the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    it 'answer with attached file' do
      fill_in 'Body', with: 'Test answer'

      attach_file 'File', [Rails.root.join('spec/rails_helper.rb').to_s, Rails.root.join('spec/spec_helper.rb').to_s]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  it 'Unauthenticated user tries to answer the question', :js do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
