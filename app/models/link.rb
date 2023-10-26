# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :name, presence: true
  validates :url, presence: true

  before_save { self.type = gist_url? ? 'Gist' : 'Link' }

  # private

  def gist_url?
    uri = URI.parse(url)
    uri.host == 'gist.github.com' && uri.path.match?(%r{^/[a-zA-Z0-9]+/[a-zA-Z0-9]+$})
  rescue URI::InvalidURIError
    false
  end
end
