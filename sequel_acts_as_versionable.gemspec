# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel_acts_as_versionable/version'

Gem::Specification.new do |gem|
  gem.name          = "sequel_acts_as_versionable"
  gem.version       = SequelActsAsVersionable::VERSION
  gem.authors       = ["Misha Conway"]
  gem.email         = ["MishaAConway@gmail.com"]
  gem.description   = %q{Versioning for Sequel ORM models. Port of Carlos Segura's acts_as_versionable.}
  gem.summary       = %q{Versioning for Sequel ORM models. Port of Carlos Segura's acts_as_versionable.}
  gem.homepage      = "https://github.com/MishaConway/sequel_acts_as_versionable"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
