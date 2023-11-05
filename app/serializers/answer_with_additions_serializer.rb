# frozen_string_literal: true

class AnswerWithAdditionsSerializer < AnswerSerializer
  include Rails.application.routes.url_helpers

  attributes :attached_files
  has_many :comments
  has_many :links

  def attached_files
    object.files.map do |file|
      rails_blob_url(file, only_path: true)
    end
  end
end
