# frozen_string_literal: true

require 'rails_helper'

describe 'User can edit his question', "
  In order to edit incorrect question
  As an authenticated user
  I'd like to be able to edit my question
" do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user, with_attachment: true) }

  describe 'Authenticated user tries to edit his question', :js do
    before do
      sign_in(user)
      visit questions_path
    end

    it 'edit question without errors' do
      visit question_path(question)

      click_on 'Edit question'

      fill_in :question_title, with: 'New question title'
      fill_in :question_body, with: 'New question body'
      click_button 'Ask'

      expect(page).not_to have_content question.body
      expect(page).to have_content 'New question title'
      expect(page).to have_content 'New question body'
    end

    it 'edit question (add links)' do
      visit question_path(question)

      click_on 'Edit question'

      form = find("turbo-frame[id=question_#{question.id}]")
      within form do
        click_button 'Add link'
        fill_in 'Link name', with: 'Link name'
        fill_in 'Url', with: 'https://ya.ru/'
        click_button 'Ask'
      end

      expect(page).to have_link 'Link name'
    end

    it 'edit question (delete links)' do
      create(:link, linkable: question)
      visit question_path(question)

      click_on 'Edit question'

      form = find("turbo-frame[id=question_#{question.id}]")
      within form do
        click_button 'X'
      end

      expect(page).not_to have_link 'MyLink'
    end

    it 'edit question with errors' do
      visit question_path(question)

      click_on 'Edit question'

      fill_in :question_title, with: ''
      fill_in :question_body, with: ''
      click_button 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_css 'textarea'
    end

    it 'delete question`s files' do
      visit question_path(question)

      click_on 'Edit question'

      uncheck('rails_helper.rb', allow_label_click: true)
      click_button 'Ask'

      expect(page).not_to have_link 'rails_helper.rb'
    end
  end

  it 'Authenticated user tries to edit not his answer', :js do
    sign_in(user)
    create(:question, user: other_user)
    visit question_path(question)

    expect(page).not_to have_link 'Edit question'
  end

  it 'Unauthenticated user tries to edit answer', :js do
    create(:question, user: other_user)
    visit question_path(question)

    expect(page).not_to have_link 'Edit question'
  end
end
