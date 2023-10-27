# frozen_string_literal: true

require 'rails_helper'

describe 'User can vote for a question', "
  In order to help others find good question
  As an authenticated user
  I'd like to be able to vote for a question
" do
  let!(:user) { create(:user) }
  let!(:question_user) { create(:user) }
  let!(:question) { create(:question, user: question_user) }

  describe 'Authenticated user, not user' do
    before do
      sign_in(user)
      visit questions_path
    end

    it 'User vote for', :js do
      visit questions_path
     within("#question_#{question.id}_votes") do
        click_on '↑'
      end

     within("#question_#{question.id}_votes") do
        expect(page).to have_content '1'
      end
    end

    it 'User vote against', :js do
      visit questions_path
     within("#question_#{question.id}_votes") do
        click_on '↓'
      end

     within("#question_#{question.id}_votes") do
        expect(page).to have_content '-1'
      end
    end

    it 'User cancel voices for and against', :js do
      visit questions_path

     within("#question_#{question.id}_votes") do
        click_on '↑'
        click_on '↑'
        click_on '↓'
        click_on '↓'
      end

     within("#question_#{question.id}_votes") do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Authenticated user, not user' do
    before do
      sign_in(question_user)
      visit questions_path
    end

    it 'user try to vote for/against', :js do
      visit questions_path

     within("#question_#{question.id}_votes") do
        expect(page).not_to have_button '↑'
        expect(page).not_to have_button '↓'
      end
    end
  end

  describe 'Not authenticated user' do
    it 'User try to vote for/against', :js do
      visit questions_path

     within("#question_#{question.id}_votes") do
        expect(page).not_to have_button '↑'
        expect(page).not_to have_button '↓'
      end
    end
  end
end
