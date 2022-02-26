# frozen_string_literal: true

require "minitest/autorun"
require "./lib/source/google_source"
require "./lib/source/local_source"
require "./lib/email/google_emails"

class GoogleEmailsTest < Minitest::Test
  def test_finding_emails_in_google_source
    Email::GoogleEmails.new(URI("https://www.protonmail.com"), Source::GoogleSource.new).list.each do |email|
      assert_match(/@protonmail.com/, email)
    end
  end

  def test_finding_in_local_source
    assert_equal(
      %w[
        Aztecdecrypt@protonmail.com mmingard@protonmail.com Corpseworm@protonmail.com nrn_1@protonmail.com
        illinoispatriot@protonmail.com Decryptdocs@protonmail.com nicecupojoe@protonmail.com
      ],
      Email::GoogleEmails.new(
        URI("https://www.protonmail.com"),
        Source::LocalSource.new(format("%s//fixtures/1-protonmail.html", File.dirname(__FILE__)))
      ).list
    )
  end
end
