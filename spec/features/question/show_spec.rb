# frozen_string_literal: true

require 'rails_helper'

describe 'User can view the question with it`s answers', "
  In order to find a solution
  As any user
  I'd like to be able to view the question with it`s answers
" do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }
  let!(:link) { create(:link, url: 'https://gist.github.com/elenachekhina/ecda8cf62dafcd6807e64fa89bba5649', linkable: question) }

  it 'Authenticated user tries to view list of questions' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end

  it 'Unauthenticated user tries to view list of questions' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end
end
