# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    unless Rails.env.test?
      include Elasticsearch::Model::Callbacks
      after_commit :index_document_on_elasticsearch, on: :create
    end
  end

  class_methods do
    def searchable_fields
      %i[body]
    end
  end

  def as_indexed_json(_options = {})
    as_json(only: self.class.searchable_fields)
  end

  def index_document_on_elasticsearch
    __elasticsearch__.index_document
  end
end
