# frozen_string_literal: true

require "minitest/autorun"
require "net/http"
require "./lib/source/google_source"

class GoogleSourceTest < Minitest::Test
  def test_returning_results
    assert_instance_of Net::HTTPResponse, Source::GoogleSource.new.responses("foobar").first
  end
end
