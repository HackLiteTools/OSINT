# frozen_string_literal: true

require "minitest/autorun"
require "net/http"
require "./lib/http/request"
require "./lib/http/user_agents"

class GoogleLanguageTest < Minitest::Test
  def test_returning_success_response
    assert_instance_of(
      Net::HTTPOK,
      Http::Request.new(URI("https://www.google.com"), Http::UserAgents.new).response
    )
  end
end
