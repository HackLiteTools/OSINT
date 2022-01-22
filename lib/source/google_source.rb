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

    def results(phrase)
      pages = []
      PAGINATION.each do |page|
        page = response(url(BASE_URL, phrase, @language, page), @user_agents).body
        pages << page.to_s unless page.nil?
      rescue Net::HTTPRequestTimeOut
        retry
      rescue Net::HTTPTooManyRequests
        raise RuntimeError "Too many requests have been sent"
      end
      pages
    end

    private

    def url(base_url, phrase, language, page)
      URI.parse(base_url + "?q=#{phrase}&lr=lang_#{language.code}&start=#{page}")
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
      http = http(url)
      http.request(request(url, user_agents))
    end
  end
end
