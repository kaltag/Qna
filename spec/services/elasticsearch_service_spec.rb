# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElasticsearchService do
  describe '#initialize' do
    it 'initializes with model and assigns @client and @klass' do
      model = 'question'
      client = double
      model.capitalize.constantize
      query = 'test'

      allow(Elasticsearch::Model).to receive(:client).and_return(client)

      service = described_class.new([model], query)

      expect(service.instance_variable_get(:@client)).to eq(client)
      expect(service.instance_variable_get(:@searchable_models)).to eq([model])
      expect(service.instance_variable_get(:@query)).to eq(query)
    end
  end

  describe '#search' do
    let(:model) { 'question' }
    let(:query) { 'body' }
    let(:service) { described_class.new([model], query) }
    let(:search_result) { double }

    it 'calls search_elastic and returns search result' do
      allow(service).to receive(:search).and_return(search_result)

      expect(service.search).to eq(search_result)
    end
  end
end
