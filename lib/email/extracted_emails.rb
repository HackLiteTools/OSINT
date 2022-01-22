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
      @sources.each do |source|
        source.results(email_domain(@domain)).each do |result|
          emails = result.scan(EMAIL_REGEX)
          @results += emails unless emails.nil?
        end
      end
      @results.uniq
    end

    private

    def email_domain(domain)
      "@#{domain.sub("@", "")}"
    end
  end
end
