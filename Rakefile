# frozen_string_literal: true
namespace :setup do
  desc 'Runs the setup'
  task :create do
    sh 'rails new test_app -m template.rb --api'
  end

  desc 'Cleans the temp setup'
  task :clean do
    sh 'rm test_app -rf'
  end
end
