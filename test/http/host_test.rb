# frozen_string_literal: true

require "minitest/autorun"
require "./lib/http/host"

class GoogleLanguageTest < Minitest::Test
  def test_returning_host_name
    assert_equal Http::Host.new(URI("https://www.google.com")).name, "google.com"
  end
end
