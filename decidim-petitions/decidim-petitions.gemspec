# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/petitions/version"

Gem::Specification.new do |s|
  s.version = Decidim::Petitions.version
  s.authors = ["Mijail Rondon"]
  s.email = ["mijail@riseup.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-petitions"
  s.required_ruby_version = ">= 2.3.1"

  s.name = "decidim-petitions"
  s.summary = "A decidim petitions module"
  s.description = "Add the functionality to work with DECODE petitions."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Petitions.version

  s.add_dependency "cells-erb", "~> 0.1.0"
  s.add_dependency "cells-rails", "~> 0.0.9"
  s.add_dependency "rqrcode", "~> 0.10"
end
