# frozen_string_literal: true

require 'rails_helper'

describe 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  let(:user) { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    it 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    it 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    it 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'Files', [Rails.root.join('spec/rails_helper.rb').to_s, Rails.root.join('spec/spec_helper.rb').to_s]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'asks a question with reward' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Name', with: 'Reward name'

      attach_file 'File', Rails.root.join('spec/fixtures/star.png').to_s
      click_on 'Ask'

      expect(page).to have_content 'With reward for best question!'
    end
  end

  it 'asks a question, multiple sessions', :js do
    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      sign_in(user)

      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end
  end

  it 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).not_to have_button 'Ask question'
  end
end
