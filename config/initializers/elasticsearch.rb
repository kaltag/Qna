# frozen_string_literal: true

host = 'http://localhost:9200/'

Elasticsearch::Model.client = Elasticsearch::Client.new(url: host, log: true)
