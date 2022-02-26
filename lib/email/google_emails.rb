# frozen_string_literal: true

require_relative "../http/host"
require_relative "../source/google_source"
require "nokogiri"

module Email
  class GoogleEmails
    def initialize(uri, source)
      @host = Http::Host.new(uri)
      @source = source
    end

    def list
      raise "Invalid source" unless valid_source? @source

      list_from_source(@host.name, @source)
    end

    private

    def valid_source?(source)
      [Source::GoogleSource, Source::LocalSource].member? source.class
    end

    def list_from_source(host, source)
      source.pages(host).reduce([]) do |pages, page|
        pages.append(*list_from_page(page, host))
      end
    end

    def list_from_page(page, host)
      search_section(page).scan(/\b[a-z0-9._-]+@#{Regexp.escape(host)}\b/i)
    end

    def search_section(page)
      Nokogiri::HTML(page).at_css("#search").inner_html
    end
  end
end
