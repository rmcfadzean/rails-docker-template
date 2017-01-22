# Rails Docker Template
A Rails template for generating a clean, new Rails (API) project with Docker, docker-compose, rspec and some nice defaults.

# Notes / Requirements

* This is **very** opinionated.
* Rails >= 5.0.0
* Ruby 2.4.0
* `--api` only (for now)

# Usage

```sh
rails new my_unicorn \
  -d postgresql \
  --api \
  -m https://raw.githubusercontent.com/rmcfadzean/rails-docker-template/master/template.rb
```
# The opinions

* Testing is done with Rspec & Rack::Test
  * Controller tests are [out](https://github.com/rails/rails/issues/18950#issuecomment-77924771)
  * Integration/request/API tests are in
* Docker & Docker compose are used for a containerised application
* Minimal frills

### Gem List

* Core
  * rails 5.0
  * postgres
  * puma
  * rack-cors - [Cross-origin resource sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
  * [health_check](https://github.com/ianheggie/health_check) - Creates a `_health` canary endpoint.
* Testing
  * rspec-rails
  * webmock - Stop hitting real endpoints! You're testing your application, not theirs.
  * database_cleaner - Cleans up your DB before and after tests so they don't interfere.
  * factory_girl_rails - Boo fixtures. Yay factories!
  * timecop - Allows you to timetravel during your tests
  * simplecov - Test coverage checker
* Debugging
  * awesome_print - `ap @object` will print out things in a nice way to help with puts debugging
  * pry-rails - `binding.pry` will save your life
  * bullet - Helps with finding N+1 queries
* Security & Style
  * rubocop - A style checker with an autofixer. Keep your code clean and readable!
  * brakeman - Static analysis for security vulns & bad practice.
  * bundler-audit - Checks your gemfile for known vulnerabilities
* Utils
  * annotate - Annotates your models, routes and factories with schema comments. Helpful for at-a-glance checks.
  * spring - For faster loading times

# Credits

* [Suspenders](https://github.com/thoughtbot/suspenders/)
* [jkxyz/rails-docker-template](https://github.com/jkxyz/rails-docker-template)
* [mattbrictson/rails-template](https://github.com/mattbrictson/rails-template)

# License

MIT
