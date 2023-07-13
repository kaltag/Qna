# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }
        end.to change(Answer, :count).by(1)
      end
    end

    it 're-renders question show view' do
      post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }
      expect(response).to redirect_to question_path(question)
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user }
        end.not_to change(Answer, :count)
      end
    end
  end

  context 'when unauthenticated user' do
    it "doesn't save a new answer in the database" do
      expect do
        post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }
      end.not_to change(Answer, :count)
    end

    it 'redirects to sign in page' do
      post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'DELETE #destroy' do
    context 'when authenticated user' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question, user_id: user } }.to change(Answer, :count).by(-1)
      end

      it 're-renders question path' do
        delete :destroy, params: { id: answer, question_id: question, user_id: user }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when unauthenticated user' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it "can't delete the question" do
        expect { delete :destroy, params: { id: answer, question_id: question, user_id: user } }.not_to change(Answer, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, params: { id: answer, question_id: question, user_id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
