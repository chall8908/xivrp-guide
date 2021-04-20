require "nokogiri"
require "uri"

require "ffxiv/lodestone/model"
require "ffxiv/lodestone/character"

module Ffxiv
  module Lodestone

    class << self
      # This provides a new URI object each time to prevent individual uses from
      # interacting with each other.
      def lodestone
        URI('https://na.finalfantasyxiv.com/lodestone/')
      end

      def fetch(endpoint, **query_hash)
        uri = lodestone
        uri.path += endpoint
        uri.query = query_hash.to_query

        html = Net::HTTP.get(uri)

        Nokogiri::HTML.parse(html)
      end
    end
  end
end
