# frozen_string_literal: true

# N+1 Checking
def apply_bullet
  config = <<-RUBY
    # N+1 Checker
    config.after_initialize do
      Bullet.enable = true
      Bullet.bullet_logger = true
      Bullet.rails_logger = true
    end
  RUBY

  inject_into_file(
    'config/environments/development.rb',
    config,
    after: "Rails.application.configure do\n"
  )
end

# Run rubocop
def run_rubocop
  bundle_command 'exec rubocop -a'
end

# RSpec
def apply_rspec
  directory 'spec'
end

# Docs
def apply_docs
  remove_file 'README.md'
  template 'README.md.tt'
end

# Gems
def apply_gemfile
  remove_file 'Gemfile'
  template 'Gemfile.tt'
end

# Dot Files
def apply_dotfiles
  copy_file 'editorconfig', '.editorconfig'
  copy_file 'rubocop.yml', '.rubocop.yml'
  copy_file 'ruby-version', '.ruby-version'
  copy_file 'env', '.env'
end

# Docker
def apply_docker
  template 'Dockerfile.tt'
  template 'docker-compose.yml.tt'
  copy_file 'dockerignore', '.dockerignore'

  # Database
  remove_file 'config/database.yml'
  template 'config/database.yml'
end

# Puma
def apply_puma
  remove_file 'config/puma.rb'
  copy_file 'config/puma.rb'
end

# Health checks
def apply_health_endpoint
  template 'config/initializers/health_checks.rb'
end

# Clean up Generators
def tidy_generators
  config = <<-RUBY
      config.generators do |g|
        g.helper          false
        g.request_specs   true
        g.routing_specs   false
        g.controller_spec false
        g.test_framework  :rspec
        g.view_specs      false
        g.javascripts     false
        g.stylesheets     false
      end
  RUBY

  inject_into_class 'config/application.rb', 'Application', config
end

# Rake tasks
def apply_tasks
  # Automatically annotate
  copy_file 'lib/tasks/auto_annotate_models.rake'
end

# Assertions
def api_project!
  puts 'Checking that this is an Rails API project'
  abort_templating unless options.api?
end

def postgres!
  puts 'Checking for Postgres'
  abort_templating unless options.database == 'postgresql'
end

# Utils

def abort_templating
  puts 'This is not an API project. Ignoring template.'
  exit
end

def add_repo_to_source
  if __FILE__.match?(%r{\Ahttps?://})
    source_root = Dir.mktmpdir('rails-docker-template')
    at_exit { FileUtils.remove_entry(source_root) }
    git clone: [
      '--quiet',
      'https://github.com/rmcfadzean/rails-docker-template.git',
      source_root
    ].map(&:shellescape).join(' ')
  else
    source_root = File.dirname(__FILE__)
  end
  source_paths.unshift(File.join(source_root, 'templates'))
end

def apply_template
  api_project!
  postgres!

  add_repo_to_source

  apply_docs
  apply_gemfile
  apply_dotfiles
  apply_docker
  apply_puma
  apply_health_endpoint
  apply_bullet
  apply_tasks
  apply_rspec

  tidy_generators

  run_rubocop
end

apply_template
