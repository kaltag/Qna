# frozen_string_literal: true

require 'rails_helper'

describe 'User can view the list of answers' do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let(:answer) { create(:answer) }

  it 'User can view the list of answers' do
    visit questions_path
    visit question_path(question)

    expect(page).to have_content answer.body
  end
end
