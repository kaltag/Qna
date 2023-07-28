require 'rails_helper'

describe 'Author of the question or the answer can delete attached files' do

  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:question) { create(:question, :with_file, user: user) }
  let!(:answer) { create(:answer, :with_file, user: user, question: question)  }

  describe 'Author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to delete the question file' do
      within '#question_files' do
        click_on 'delete file'
      end
      expect(page).not_to have_link 'rails_helper.rb'
    end

    scenario 'tries to delete the answer file' do
      within "#answer_files_#{answer.id}" do
        click_on 'delete file'
      end
      expect(page).not_to have_link 'rails_helper.rb'
    end
  end

  scenario 'Not an author tries to delete the file' do
    sign_in(user_2)
    visit question_path(question)

    expect(page).not_to have_link('delete file')
  end
end