# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "decidim"
set :repo_url, "https://github.com/alabs/DDDC.git"
set :branch, "master"

append :linked_files, "config/database.yml", ".rbenv-vars"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle"

set :rbenv_type, :user
set :rbenv_ruby, "2.4.2"
set :rbenv_path, "/home/ruby-data/.rbenv"
set :delayed_job_workers, 1
set :passenger_restart_with_touch, true
