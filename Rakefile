# frozen_string_literal: true

require "rake/testtask"
require "rubocop/rake_task"

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |task|
  task.libs << "test"
  task.libs << "lib"
  task.test_files = FileList["test/**/*_test.rb"]
end

task default: %i[rubocop test]
