# frozen_string_literal: true

require 'rails_helper'

describe 'Authenticated user tries to edit his question' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_question) { create(:question, user: other_user) }

  before do
    sign_in(user)

    visit question_path(question)
    click_on 'Edit question'
  end

  it 'edit question without errors' do
    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'New question body'
    attach_file 'File', [Rails.root.join('spec/rails_helper.rb').to_s, Rails.root.join('spec/spec_helper.rb').to_s]
    click_button 'Ask'

    expect(page).not_to have_content question.body
    expect(page).to have_content 'New question title'
    expect(page).to have_content 'New question body'
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

  it 'edit question with errors' do
    fill_in :question_title, with: ''
    fill_in :question_body, with: ''
    click_button 'Ask'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  it 'Authenticated user tries to edit not his question' do
    visit question_path(other_question)

    expect(page).not_to have_link 'Edit question'
  end
end

describe 'Unauthenticated user tries to edit question' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'Unauthenticated user tries to edit question' do
    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end
end
