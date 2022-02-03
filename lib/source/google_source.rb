# frozen_string_literal: true

require "net/http"
require "openssl"
require_relative "google_language"
require_relative "user_agents"

module Source
  class GoogleSource
    BASE_URL = "https://www.google.com/search"
    LANGUAGE_CODE = "en"
    PAGINATION = (10..50).step(10)

    def initialize(
      language = Source::GoogleLanguage.new(LANGUAGE_CODE),
      user_agents = Source::UserAgents.new
    )
      @language = language
      @user_agents = user_agents
    end

    def responses(phrase)
      PAGINATION.map do |pagination|
        response(url(BASE_URL, phrase, @language, pagination), @user_agents)
      end
    end

    private

    def url(base_url, phrase, language, pagination)
      URI.parse(base_url + "?q=#{phrase}&lr=lang_#{language.code}&start=#{pagination}")
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

    def response(url, user_agents)
      response = http(url).request(request(url, user_agents))
      case response
      when Net::HTTPSuccess then response
      when Net::HTTPRedirection then "Redirected to a captcha page"
      when Net::HTTPRequestTimeOut then response(url, user_agents)
      when Net::HTTPTooManyRequests then "Too many requests have been sent"
      else
        raise "Request failed"
      end
    end
  end
end
