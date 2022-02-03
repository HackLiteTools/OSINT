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
      list = @sources.map do |source|
        list_from_source(source, email_domain(@domain))
      end
      list.uniq
    end

    private

    def list_from_source(source, email_domain)
      source.responses(email_domain).map do |response|
        list_from_body(body(response))
      end
    end

    def email_domain(domain)
      "@#{domain.sub("@", "")}"
    end

    def list_from_body(body)
      body.scan(/\b[A-Z0-9._-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
    end

    def body(response)
      Nokogiri::HTML(response.body).at("body").inner_html
    end
  end
end
