# frozen_string_literal: true

require "net/http"
require "openssl"
require_relative "google_language"
require_relative "../http/request"
require_relative "../http/user_agents"

module Source
  class GoogleSource
    BASE_URL = "https://www.google.com/search"
    LANGUAGE_CODE = "en"
    STEPS = (10..50).step(10)

    private_constant :BASE_URL, :LANGUAGE_CODE, :STEPS

    def initialize(
      language = Source::GoogleLanguage.new(LANGUAGE_CODE),
      user_agents = Http::UserAgents.new
    )
      @language = language
      @user_agents = user_agents
    end

    def pages(phrase)
      STEPS.map do |step|
        Http::Request.new(uri(BASE_URL, phrase, @language, step), @user_agents).response.body
      end
    end

    private

    def uri(base_url, phrase, language, step)
      URI.parse(base_url + "?q=#{phrase}&lr=lang_#{language.code}&start=#{step}")
    end
  end
end
