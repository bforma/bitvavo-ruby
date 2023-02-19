module Bitvavo
  class RequestSigner
    def self.sign_request(timestamp:, method:, path:, body:, secret: Bitvavo.configuration.api_secret)
      fail "No API secret configured" unless secret

      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha256"),
        secret,
        "#{timestamp}#{method.to_s.upcase}#{path}#{body}"
      )
    end
  end
end
