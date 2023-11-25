# frozen_string_literal: true

host = 'http://79.174.94.218:9200/'

Elasticsearch::Model.client = Elasticsearch::Client.new(url: host, log: true)
