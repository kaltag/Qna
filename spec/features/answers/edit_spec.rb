# frozen_string_literal: true

require 'rails_helper'

describe 'Authenticated user tries to edit his answer' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:other_answer) { create(:answer, body: 'Other_Ans', question: question, user: other_user) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  it 'edit answer' do
    within '#answers' do
      click_on answer.body.to_s
    end

    form = find("turbo-frame[id=inline_answer_#{answer.id}]")
    within form do
      fill_in 'Body', with: 'New answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_button 'Save'
    end

    expect(page).not_to have_content answer.body
    expect(page).to have_content 'New answer body'
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

  it 'edit answer with errors' do
    within '#answers' do
      click_on answer.body.to_s
    end

    form = find("turbo-frame[id=inline_answer_#{answer.id}]")
    within form do
      fill_in 'Body', with: ''
      click_button 'Save'
    end

    expect(page).to have_content "Body can't be blank"
  end

  it 'Authenticated user tries to edit not his answer' do
    within '#answers' do
      expect(page).not_to have_link other_answer.body.to_s
    end
  end
end

describe 'Unauthenticated user tries to edit question' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    within '#answers' do
      expect(page).not_to have_link answer.body.to_s
    end
  end
end
