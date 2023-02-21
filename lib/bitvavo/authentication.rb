require_relative "request_signer"

module Bitvavo
  class Authentication < Faraday::Middleware
    def on_request(env)
      fail "No API key configured" unless Bitvavo.configuration.api_key

      timestamp = (Time.now.to_f * 1_000).to_i

      env.request_headers["Bitvavo-Access-Key"] = Bitvavo.configuration.api_key
      env.request_headers["Bitvavo-Access-Signature"] = RequestSigner.sign_request(
        timestamp: timestamp,
        method: env.method,
        path: env.url.path,
        query: env.url.query,
        body: env.body
      )
      env.request_headers["Bitvavo-Access-Timestamp"] = timestamp.to_s
    end
  end
end
