# frozen_string_literal: true

require "minitest/autorun"
require "./lib/source/google_source"
require "./lib/email/extracted_emails"

class ExtractedEmailsTest < Minitest::Test
  def test_finding_emails_in_source
    assert_match(
      /@protonmail.com/,
      Email::ExtractedEmails.new("protonmail.com", Source::GoogleSource.new).list.to_s
    )
  end
end
