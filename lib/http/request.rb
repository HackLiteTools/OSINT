# frozen_string_literal: true

require "net/http"

module Http
  class Request
    def initialize(uri, user_agents)
      @uri = uri
      @user_agents = user_agents
    end

    def response(limit = 10)
      raise "Number of requests exceeded limit" if limit.zero?

      response = http(@uri).request(request(@uri, @user_agents))
      case response
      when Net::HTTPOK then response
      when Net::HTTPRedirection then raise "Redirected to a captcha page"
      when Net::HTTPRequestTimeOut then response(limit - 1)
      when Net::HTTPTooManyRequests then raise "Too many requests have been sent"
      else
        raise "Request failed"
      end
    end

    private

    def http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def request(uri, user_agents)
      request = Net::HTTP::Get.new(uri.request_uri)
      request["User-Agent"] = user_agents.sample
      request
    end
  end
end
