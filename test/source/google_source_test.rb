# frozen_string_literal: true

require "minitest/autorun"
require "./lib/source/google_source"

class GoogleSourceTest < Minitest::Test
  def test_returning_results
    assert_includes Source::GoogleSource.new.results("foobar", /foobar/), "foobar"
  end
end
