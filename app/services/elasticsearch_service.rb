# frozen_string_literal: true

class ElasticsearchService
  def initialize(models, query)
    @client = Elasticsearch::Model.client
    @searchable_models = models || %w[question answer comment user]
    @query = query
  end

  def search
    @searchable_models.index_with do |model|
      klass(model).find(search_elastic(model, @query))
    end
  end

  private

  def search_elastic(model, query)
    klass(model).search("*#{query}*").results.map(&:_id)
  end

  def klass(model)
    model.capitalize.constantize
  end
end
