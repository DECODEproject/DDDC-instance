# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION


DECIDIM_VERSION = { git: "https://github.com/decidim/decidim.git", branch: "master" }

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", "0.13.1"
# gem "decidim-initiatives", "0.13.1"

gem "bootsnap", "~> 1.3"
gem "puma", "~> 3.0"
gem "uglifier", "~> 4.1"
gem "faker", "~> 1.8"
gem "daemons"
gem "delayed_job_active_record"
gem "decidim-petitions", path: "."

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  # deploy
  gem "capistrano", "3.10.2", require: false
  gem "capistrano-bundler", "~> 1.2", require: false
  gem "capistrano-passenger"
  gem "capistrano-rails", "1.1.8", require: false
  gem "capistrano-rbenv"
  gem "capistrano3-delayed-job", "~> 1.0"
  gem "ed25519"
  gem "bcrypt_pbkdf"
end

group :production do
  gem 'passenger'
  gem 'fog-aws'
  gem 'dalli'
  gem 'sendgrid-ruby'
  gem 'newrelic_rpm'
  gem 'lograge'
  gem 'sentry-raven'
  gem 'sidekiq'
end
