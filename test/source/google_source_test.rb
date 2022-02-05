# frozen_string_literal: true

require "minitest/autorun"
require "net/http"
require "./lib/source/google_source"

class GoogleSourceTest < Minitest::Test
  def test_returning_results
    assert_match %r{</body>}, Source::GoogleSource.new.pages("foobar").first
  end
end
