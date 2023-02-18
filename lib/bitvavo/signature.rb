module Bitvavo
  class Signature
    def self.create(secret, timestamp, method, path, body)
      fail "No API secret configured" unless secret

      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha256"),
        secret,
        "#{timestamp}#{method}#{path}#{body}"
      )
    end
  end
end
