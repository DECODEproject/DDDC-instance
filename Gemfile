# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = {
  git: 'https://github.com/decidim/decidim.git',
  branch: 'master'
}.freeze

gem 'decidim', DECIDIM_VERSION
# gem 'decidim-consultations', '0.13.1'
# gem 'decidim-initiatives', '0.13.1'

gem 'bootsnap', '~> 1.3'
gem 'decidim-petitions', path: '.'
gem 'faker', '~> 1.8'
gem 'figaro'
gem 'puma', '~> 3.0'
gem 'sidekiq'
gem 'uglifier', '~> 4.1'

group :development, :test do
  gem 'byebug', '~> 10.0', platform: :mri

  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'

  # deploy
  gem 'bcrypt_pbkdf'
  gem 'capistrano', '3.10.2', require: false
  gem 'capistrano-bundler', '~> 1.2', require: false
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '1.1.8', require: false
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
  gem 'ed25519'
end

group :production do
  gem 'dalli'
  gem 'fog-aws'
  gem 'lograge'
  gem 'newrelic_rpm'
  gem 'passenger'
  gem 'sendgrid-ruby'
  gem 'sentry-raven'
end
