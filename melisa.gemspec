# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'melisa/version'

Gem::Specification.new do |gem|
  gem.name = "melisa"
  gem.summary = "Melisa is a Rubyesque wrapper for the Marisa Trie C library"
  gem.description = "While marisa-trie provides a ruby binding, it is not particularly rubyesque. Melisa fixes that."
  gem.homepage = "http://github.com/wordtreefoundation/melisa"
  gem.authors = ['Duane Johnson']
  gem.email = ['duane.johnson@gmail.com']
  gem.licenses = ["MIT"]

  gem.files = %w[melisa.gemspec README.md]
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")

  gem.test_files = Dir.glob("spec/**/*")
  gem.require_paths = ["lib"]
  gem.version = Melisa::VERSION
  gem.required_ruby_version = '>= 1.9.0'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_development_dependency "debugger"
end
