# frozen_string_literal: true

require 'rails_helper'

describe 'Authenticated user tries to mark best answer on his question' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: other_user) }

  before do
    sign_in(user)
    visit questions_path
  end

  it 'mark one answer' do
    visit question_path(question)

    within "#answer_#{answers[0].id}" do
      click_on 'Mark'
    end

    within "#answer_#{answers[0].id}" do
      expect(page).to have_content 'Best answer'
    end
    within "#answer_#{answers[1].id}" do
      expect(page).not_to have_content 'Best answer'
    end
  end

  it 'mark other answer' do
    visit question_path(question)

    within "#answer_#{answers[0].id}" do
      click_on 'Mark'
    end

    within "#answer_#{answers[1].id}" do
      click_on 'Mark'
    end

    assert_selector 'div[id="answers"]', wait: 10

    within "#answer_#{answers[0].id}" do
      expect(page).not_to have_content 'Best answer'
    end
    within "#answer_#{answers[1].id}" do
      expect(page).to have_content 'Best answer'
    end
  end

  it 'mark answer and it stand first place' do
    visit question_path(question)

    within "#answer_#{answers[1].id}" do
      click_on 'Mark'
    end

    sleep(2)

    expect(page.body).to match(/.*#{answers[1].body}.*#{answers[0].body}.*/m)
  end
end
