# -*- encoding: utf-8 -*-
# stub: anycable-rails 1.6.1 ruby lib

Gem::Specification.new do |s|
  s.name = "anycable-rails".freeze
  s.version = "1.6.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://github.com/anycable/anycable-rails/issues", "changelog_uri" => "https://github.com/anycable/anycable-rails/blob/master/CHANGELOG.md", "documentation_uri" => "https://docs.anycable.io/#/using_with_rails", "funding_uri" => "https://github.com/sponsors/anycable", "homepage_uri" => "https://anycable.io/", "source_code_uri" => "http://github.com/anycable/anycable-rails" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["palkan".freeze]
  s.date = "2025-12-17"
  s.description = "AnyCable integration for Rails".freeze
  s.email = ["dementiev.vm@gmail.com".freeze]
  s.homepage = "http://github.com/anycable/anycable-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.19".freeze
  s.summary = "AnyCable integration for Rails".freeze

  s.installed_by_version = "3.5.16".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<anycable-rails-core>.freeze, ["= 1.6.1".freeze])
  s.add_runtime_dependency(%q<anycable>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<ammeter>.freeze, ["~> 1.1".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1.10".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze])
  s.add_development_dependency(%q<rspec-rails>.freeze, [">= 4.0.0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 1.0".freeze])
  s.add_development_dependency(%q<warden>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov-lcov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<toml>.freeze, ["~> 0.3.0".freeze])
end
