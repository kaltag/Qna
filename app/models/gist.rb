# frozen_string_literal: true

class Gist < Link
  def body
    GistService.new.gist(url_id)
  end

  private

  def url_id
    path = URI.parse(url).path
    File.basename(path)
  end
end
