# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController do
  let!(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user_id: user.id) }

    before { get :index }

    it 'populates ad array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'creates new subscription' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.subscriptions, :count).by(1)
      end

      it 'saves a new question`s links in the database' do
        expect do
          post :create,
               params: { question: attributes_for(:question, links_attributes: { 0 => attributes_for(:link) }) }
        end.to change(Link.all, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.not_to change(user.questions, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user_id: user.id) }

    it 'delete question from database' do
      expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } },
                       format: :turbo_stream

        expect(question.reload.title).to eq 'new title'
        expect(question.reload.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } },
                       format: :turbo_stream
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        patch :update, params: { id: question, question: { title: '', body: '' } }, format: :turbo_stream
        expect(question.reload.title).to eq question.title
        expect(question.reload.body).to eq question.body
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: '', body: '' } }, format: :turbo_stream
        expect(response).to render_template :update
      end
    end
  end
end
