# frozen_string_literal: true

require "minitest/autorun"
require "./lib/source/google_language"

class GoogleLanguageTest < Minitest::Test
  def test_returning_valid_language_code
    assert_same Source::GoogleLanguage.new("en").code, "en"
  end

  def test_raising_on_invalid_language_code
    exception = assert_raises ArgumentError do
      Source::GoogleLanguage.new("invalid").code
    end
    assert_same("Language code is invalid", exception.message)
  end
end
