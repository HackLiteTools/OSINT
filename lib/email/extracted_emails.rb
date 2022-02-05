# frozen_string_literal: true

require_relative "../source/google_source"
require "nokogiri"

module Email
  class ExtractedEmails
    def initialize(domain, *sources)
      @domain = domain
      @sources = sources
    end

    def list
      list = @sources.reduce([]) do |all, source|
        all.append(*list_from_source(source, email_domain(@domain)))
      end

      list.uniq
    end

    private

    def list_from_source(source, email_domain)
      source.responses(email_domain).reduce([]) do |all, body|
        all.append(*list_from_body(search_section(body)))
      end
    end

    def email_domain(domain)
      "@#{domain.sub("@", "")}"
    end

    def list_from_body(body)
      body.scan(/\b[A-Z0-9._-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
    end

    def search_section(body)
      Nokogiri::HTML(body).at_css("#search").inner_html
    end
  end
end
