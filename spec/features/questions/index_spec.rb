# frozen_string_literal: true

require 'rails_helper'

describe 'User can view the list of questions' do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  it 'User can view the list of questions' do
    visit questions_path

    expect(page).to have_content question.title
  end
end
