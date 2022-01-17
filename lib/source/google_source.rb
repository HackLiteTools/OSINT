# frozen_string_literal: true

require "open-uri"

module Source
  class GoogleSource
    TOP_LEVEL_DOMAIN = "com"
    LANGUAGE = "en"
    ENCODING = "UTF-8"
    PAGINATION = (10..50).step(10)

    def initialize(top_level_domain = TOP_LEVEL_DOMAIN, language = LANGUAGE)
      @top_level_domain = top_level_domain
      @language = language
      @base_url = "https://www.google.#{top_level_domain}/search"
      @results = []
    end

    def results(phrase, regex)
      PAGINATION.each do |page|
        URI.parse(@base_url + "?q=#{phrase}&lr=lang_#{@language}&ie=#{ENCODING}&start=#{page}").open do |file|
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
