# frozen_string_literal: true

require_relative "../source/google_source"

module Email
  class ExtractedEmails
    EMAIL_REGEX = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i

    def initialize(domain, *sources)
      @domain = domain
      @sources = sources
      @results = []
    end

    def list
      @sources.map { |source| @results += source.results(domain, EMAIL_REGEX) }
      @results.uniq
    end

    private

    def domain
      "@#{@domain.sub("@", "")}"
    end
  end
end
