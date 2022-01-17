# frozen_string_literal: true

require "open-uri"

module Source
  class GoogleSource
    TOP_LEVEL_DOMAIN = "com"
    ENCODING = "UTF-8"
    PAGINATION = (10..50).step(10)

    def initialize(top_level_domain = TOP_LEVEL_DOMAIN)
      @top_level_domain = top_level_domain
      @base_url = "https://www.google.#{top_level_domain}/search"
      @results = []
    end

    def results(phrase, regex, encoding = ENCODING)
      PAGINATION.each do |page|
        URI.parse(@base_url + "?q=#{phrase}&hl=en&lr=&ie=#{encoding}&start=#{page}&sa=N").open do |file|
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
