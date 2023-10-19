# frozen_string_literal: true

require 'rails_helper'

describe 'User can receive a reward', "
  In order to recieve points
  As an authenticated user
  I'd like to be able to receive a reward for best answer
" do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:reward) { create(:reward, question: question) }
  let(:answer_user) { create(:user) }

  before do
    sign_in(answer_user)
    visit questions_path
  end

  it 'User`s answer marked as best' do
    create(:answer, question: question, user: answer_user, mark: true)

    visit rewards_path

    expect(page).to have_content reward.name
    expect(page).to have_content reward.question.title
  end

  it 'User`s answer not marked as best' do
    create(:answer, question: question, user: answer_user, mark: false)

    visit rewards_path

    expect(page).not_to have_content reward.name
    expect(page).not_to have_content reward.question.title
  end
end
