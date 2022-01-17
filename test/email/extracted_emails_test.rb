# frozen_string_literal: true

require "minitest/autorun"
require "./lib/source/google_source"
require "./lib/email/extracted_emails"

class GoogleSourceTest < Minitest::Test
  def test_listing_emails
    assert_match /@protonmail.com/, Email::ExtractedEmails.new(Source::GoogleSource.new, "protonmail.com").list.to_s
  end
end
