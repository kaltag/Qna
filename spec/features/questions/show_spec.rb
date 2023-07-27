# frozen_string_literal: true

require 'rails_helper'

describe 'User can view question with answers' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }

  it 'User tries to watch question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
    expect(page).to have_content answers[2].body
  end
end
