# frozen_string_literal: true

require "net/http"
require "openssl"
require_relative "google_language"
require_relative "user_agents"

module Source
  class GoogleSource
    BASE_URL = "https://www.google.com/search"
    LANGUAGE_CODE = "en"
    STEPS = (10..50).step(10)

    private_constant :BASE_URL, :LANGUAGE_CODE, :STEPS

    def initialize(
      language = Source::GoogleLanguage.new(LANGUAGE_CODE),
      user_agents = Source::UserAgents.new
    )
      @language = language
      @user_agents = user_agents
    end

    def pages(phrase)
      STEPS.map do |step|
        response(url(BASE_URL, phrase, @language, step), @user_agents).body
      end
    end

    private

    def url(base_url, phrase, language, step)
      URI.parse(base_url + "?q=#{phrase}&lr=lang_#{language.code}&start=#{step}")
    end

    def http(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def request(url, user_agents)
      request = Net::HTTP::Get.new(url.request_uri)
      request["User-Agent"] = user_agents.sample
      request
    end

    def response(url, user_agents, limit = 10)
      raise "Number of requests exceeded limit" if limit.zero?

      response = http(url).request(request(url, user_agents))
      case response
      when Net::HTTPOK then response
      when Net::HTTPRedirection then "Redirected to a captcha page"
      when Net::HTTPRequestTimeOut then response(url, user_agents, limit - 1)
      when Net::HTTPTooManyRequests then "Too many requests have been sent"
      else
        raise "Request failed"
      end
    end
  end
end
