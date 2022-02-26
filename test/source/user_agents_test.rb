# frozen_string_literal: true

require "minitest/autorun"
require "./lib/http/user_agents"

class UserAgentsTest < Minitest::Test
  def test_rotation
    user_agents = Http::UserAgents.new

    first = user_agents.sample
    second = user_agents.sample

    assert first != second
  end
end
