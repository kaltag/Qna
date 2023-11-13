# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'GET #search' do
    let!(:service) { instance_double(ElasticsearchService) }
    let(:query) { 'query' }
    let(:model) { 'question' }

    before do
      allow(ElasticsearchService).to receive(:new).and_return(service)
      allow(service).to receive(:search)
    end

    it 'calls ElasticsearchService' do
      get :search, params: { query: query, model: model, searchables_model: [model] }
      expect(ElasticsearchService).to have_received(:new).with([model], query)
      expect(service).to have_received(:search)
    end

    it 'renders search/index' do
      get :search, params: { query: query, model: model, searchables_model: [model] }

      expect(response).to render_template 'search/index'
    end
  end
end
