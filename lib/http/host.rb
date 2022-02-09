# frozen_string_literal: true

require "net/http"

module Http
  class Host
    def initialize(uri)
      @uri = uri
    end

    def name
      host = @uri.host.downcase
      host.start_with?("www.") ? host[4..] : host
    end
  end
end
