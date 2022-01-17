# frozen_string_literal: true

require "open-uri"
require_relative "google_language"

module Source
  class GoogleSource
    BASE_URL = "https://www.google.com/search"
    LANGUAGE_CODE = "en"
    PAGINATION = (10..50).step(10)

    def initialize(language = Source::GoogleLanguage.new(LANGUAGE_CODE))
      @language = language
      @results = []
    end

    def results(phrase, regex)
      PAGINATION.each do |page|
        URI.parse(BASE_URL + "?q=#{phrase}&lr=lang_#{@language.code}&start=#{page}").open do |file|
          file.each_line do |line|
            result = line.match(regex)
            @results << result.to_s if result
          end
        end
      end
      @results
    end
  end
end
