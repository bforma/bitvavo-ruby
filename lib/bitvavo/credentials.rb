require "yaml"

module Bitvavo
  class Credentials
    PATH = "#{Dir.home}/.bitvavo/credentials"

    class << self
      def [](key)
        load_credentials unless @credentials

        @credentials[key]
      end

      def reset!
        @credentials = nil
      end

      private

      def load_credentials
        @credentials = if File.exist?(path)
          YAML.load_file(path)
        else
          {}
        end
      end

      def path
        PATH
      end
    end
  end
end
