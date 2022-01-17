# frozen_string_literal: true

require_relative "../source/google_source"

module Email
  class ExtractedEmails
    EMAIL_REGEX = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i

    def initialize(source, domain)
      @source = source
      @domain = domain
    end

    def list
      @source.results("@#{@domain}", EMAIL_REGEX)
    end
  end
end
