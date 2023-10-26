# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #new' do
    before { get question_path(question) }

    it 'assign question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @new_answer' do
      expect(assigns(:new_answer)).to be_a_new(Answer).with(question_id: question.id)
    end

    it 'assigns a new Link to first answer`s links' do
      expect(assigns(:new_answer).links.first).to be_a_new(Link)
    end

    it 'renders answers/_new view' do
      expect(response).to render_template 'answers/_new'
    end

    it 'renders links/_new view' do
      expect(response).to render_template 'links/_new'
    end
  end

  describe 'POST #create', :js do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new question`s answer in the database' do
        expect do
          post question_answers_path(question,
                                     params: { answer: attributes_for(:answer) })
        end.to change(question.answers, :count).by(1)
                                               .and change(
                                                 user.answers, :count
                                               ).by(1)
      end

      it 'saves a new answer`s links in the database' do
        expect  do
          post question_answers_path(question,
                                     params: { answer: attributes_for(:answer,
                                                                      links_attributes: { 0 => attributes_for(:link) }) })
        end.to change(Link.all, :count).by(1)
      end

      it 'redirect to question show view' do
        post question_answers_path(question, params: { answer: attributes_for(:answer) })
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post question_answers_path(question,
                                     params: { answer: attributes_for(:answer, :answer_invalid) })
        end.to change(question.answers, :count).by(0)
                                               .and change(
                                                 user.answers, :count
                                               ).by(0)
      end

      it 're-render new view' do
        post question_answers_path(question, params: { answer: attributes_for(:answer, :answer_invalid) })
        expect(response).to render_template 'answers/_new'
      end
    end
  end

  describe 'DELETE #destroy', :js do
    before { sign_in(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    it 'delete answer from database' do
      expect { delete answer_path(answer) }.to change(question.answers, :count).by(-1)
                                                                               .and change(user.answers, :count).by(-1)
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch answer_path(answer, answer: { body: 'new body test' }), params: { format: :turbo_stream }
        expect(answer.reload.body).to eq 'new body test'
      end

      it 'renders update view' do
        patch answer_path(answer, answer: { body: 'new body' }), params: { format: :turbo_stream }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch answer_path(answer, answer: { body: '' }), params: { format: :turbo_stream }
        end.not_to change(answer, :body)
      end

      it 'renders update view' do
        patch answer_path(answer, answer: { body: 'new body' }), params: { format: :turbo_stream }
        expect(response).to render_template :update
      end
    end
  end

  describe 'POST #mark' do
    before { sign_in(user) }

    context 'mark answer as best' do
      it 'changes mark to true' do
        answer = create(:answer, question: question, user: user)
        post mark_answer_path(answer), params: { format: :turbo_stream }
        expect(answer.reload.mark).to be true
      end

      it 'changes mark to false' do
        answer = create(:answer, question: question, user: user, mark: true)
        post mark_answer_path(answer), params: { format: :turbo_stream }
        expect(answer.reload.mark).to be false
      end
    end
  end
end
