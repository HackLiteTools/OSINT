# frozen_string_literal: true

require "open-uri"

module Source
  class GoogleSource
    BASE_URL = "https://www.google.com/search"
    LANGUAGE = "en"
    ENCODING = "UTF-8"
    PAGINATION = (10..50).step(10)

    def initialize(language = LANGUAGE, encoding = ENCODING)
      @language = language
      @encoding = encoding
      @results = []
    end

    def results(phrase, regex)
      PAGINATION.each do |page|
        URI.parse(BASE_URL + "?q=#{phrase}&lr=lang_#{@language}&ie=#{@encoding}&start=#{page}").open do |file|
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
