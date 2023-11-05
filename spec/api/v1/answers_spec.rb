# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }
  let(:headers_with_token) { headers.merge({ 'Authorization' => "Bearer #{access_token.token}" }) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let(:answer_public_fields) { %w[id body user_id mark created_at updated_at] }
  let(:question) { create(:question, user: create(:user)) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:answers) { create_list(:answer, 2, user: create(:user), question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer) { answers.first }
      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { get api_path, headers: headers_with_token }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_response.size).to eq 2
      end

      it 'returns all public fields' do
        answer_public_fields.each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user: create(:user), question: question, with_attachment: true) }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, headers: headers_with_token }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        answer_public_fields.each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it_behaves_like 'Linkable' do
        let(:link) { links.first }
        let(:links_response) { answer_response['links'] }
      end

      it_behaves_like 'Commentable' do
        let(:comment) { comments.first }
        let(:comments_response) { answer_response['comments'] }
      end

      it_behaves_like 'Attachable' do
        let(:attachs_response) { answer_response['attached_files'] }
        let(:attachable) { answer }
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:params) { { answer: attributes_for(:answer) } }

        it 'returns success status' do
          post api_path, params: params, headers: headers_with_token
          expect(response).to be_successful
        end

        it 'creates new question answer' do
          expect { post api_path, params: params, headers: headers_with_token }.to change(question.answers, :count).by(1)
        end

        it 'creates question with correct fields' do
          post api_path, params: params, headers: headers_with_token
          expect(user.answers.last.body).to eq(params[:answer][:body])
        end
      end

      context 'with invalid attributes' do
        let(:params) { { answer: { body: '' } } }

        it 'does not create new answer' do
          expect { post api_path, params: params, headers: headers_with_token }.not_to change(question.answers, :count)
        end

        it 'returns an error' do
          post api_path, params: params, headers: headers_with_token
          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:params) { { answer: { body: 'New body New body' } } }

        it 'returns success status' do
          patch api_path, params: params, headers: headers_with_token
          expect(response).to be_successful
        end

        it 'update fields' do
          patch api_path, params: params, headers: headers_with_token
          answer.reload
          expect(answer.body).to eq(params[:answer][:body])
        end
      end

      context 'with invalid attributes' do
        let(:params) { { answer: { body: '' } } }

        it 'returns an error' do
          patch api_path, params: params, headers: headers_with_token
          expect(json).to have_key('errors')
        end
      end

      context 'user try to change not his answer' do
        let!(:other_answer) { create(:answer, user: create(:user), question: question) }
        let(:params) { { answer: { body: 'New body' } } }
        let(:api_path) { "/api/v1/answers/#{other_answer.id}" }

        it 'returns an error' do
          patch api_path, params: params, headers: headers_with_token
          expect(json).to have_key('errors')
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'user try to destroy his question' do
        it 'returns 200 status' do
          delete api_path, headers: headers_with_token
          expect(response).to be_successful
        end

        it 'destroy the question' do
          expect { delete api_path, headers: headers_with_token }.to change(question.answers, :count).by(-1)
        end
      end

      context 'user try to destroy not his question' do
        let!(:other_answer) { create(:answer, user: create(:user), question: question) }
        let(:api_path) { "/api/v1/questions/#{other_answer.id}" }

        it 'returns 403 status' do
          delete api_path, headers: headers_with_token
          expect(response).to have_http_status :forbidden
        end

        it 'destroy the question' do
          delete api_path, headers: headers_with_token

          expect { delete api_path, headers: headers_with_token }.not_to change(Answer, :count)
        end
      end
    end
  end
end
