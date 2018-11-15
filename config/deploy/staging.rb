server "stag-decidim-uoc-ddcc", roles: %w(app db web worker)
set :branch, ENV['branch'] || 'master'
set :rails_env, "staging"
