# frozen_string_literal: true

require 'rails_helper'

describe 'User can edit his answer', "
  In order to edit incorrect answer
  As an authenticated user
  I'd like to be able to edit my answer
" do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user, with_attachment: true) }

  describe 'Authenticated user tries to edit his answer', :js do
    before do
      sign_in(user)
      visit questions_path
    end

    it 'edit answer without errors' do
      visit question_path(question)

      within '#answers' do
        click_on answer.body.to_s
      end

      form = find("turbo-frame[id=inline_answer_#{answer.id}]")
      within form do
        fill_in :answer_body, with: 'New answer body'
        click_button 'Answer'
      end

      expect(page).not_to have_content answer.body
      expect(page).to have_content 'New answer body'
      expect(page).not_to have_selector "#inline_answer_#{answer.id}"
    end

    it 'edit answer (add links)' do
      visit question_path(question)

      within '#answers' do
        click_on answer.body.to_s
      end

      form = find("turbo-frame[id=inline_answer_#{answer.id}]")
      within form do
        click_button 'Add link'
        fill_in 'Link name', with: 'Link name'
        fill_in 'Url', with: 'https://ya.ru/'
        click_button 'Answer'
      end

      expect(page).to have_link 'Link name'
    end

    it 'edit answer (delete links)' do
      create(:link, linkable: answer)
      visit question_path(question)

      within '#answers' do
        click_on answer.body.to_s
      end

      form = find("turbo-frame[id=inline_answer_#{answer.id}]")
      within form do
        click_button 'X'
      end

      expect(page).not_to have_link 'MyLink'
    end

    it 'edit answer with errors' do
      visit question_path(question)

      within '#answers' do
        click_on answer.body.to_s
      end

      form = find("turbo-frame[id=inline_answer_#{answer.id}]")
      within form do
        fill_in :answer_body, with: ''
        click_button 'Answer'
      end

      expect(page).to have_content answer.body
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_css 'textarea'
    end

    it 'delete answer`s files' do
      visit question_path(question)

      within '#answers' do
        click_on answer.body.to_s
        uncheck('rails_helper.rb', allow_label_click: true)
        click_button 'Answer'
      end

      expect(page).not_to have_link 'rails_helper.rb'
    end
  end

  it 'Authenticated user tries to edit not his answer', :js do
    sign_in(user)
    other_answer = create(:answer, question: question, user: other_user)
    visit question_path(question)

    within '#answers' do
      expect(page).not_to have_link other_answer.body.to_s
    end
  end

  it 'Unauthenticated user tries to edit answer', :js do
    visit question_path(question)

    within '#answers' do
      expect(page).not_to have_link answer.body.to_s
    end
  end
end
