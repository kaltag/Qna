# frozen_string_literal: true

module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    params = options[:params] || {}
    headers = options[:headers] || {}
    send method, path, params: params, headers: headers
  end
end
