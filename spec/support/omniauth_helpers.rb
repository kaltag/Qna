# frozen_string_literal: true

module OmniauthHelpers
  def mock_auth(provider, email = nil)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
                                                                   'provider' => provider.to_s,
                                                                   'uid' => '123545',
                                                                   'info' => {
                                                                     'email' => email
                                                                   }
                                                                 })
  end
end
