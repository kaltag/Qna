# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  shared_examples_for 'returns public fields' do
    it 'returns all public fields' do
      %w[id email admin created_at updated_at].each do |attr|
        expect(resource_response[attr]).to eq resource.send(attr).as_json
      end
    end

    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        expect(resource_response).not_to have_key(attr)
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      it { expect(response).to be_successful }

      it_behaves_like 'returns public fields' do
        let(:resource_response) { json['user'] }
        let(:resource) { user }
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    let(:api_path) { '/api/v1/profiles/others' }
    let!(:others) { create_list(:user, 3) }
    let(:other) { others.first }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it { expect(response).to be_successful }

    it 'returns array of 3 users' do
      expect(json['users'].size).to eq 3
    end

    it_behaves_like 'returns public fields' do
      let(:resource_response) { json['users'].first }
      let(:resource) { other }
    end
  end
end
