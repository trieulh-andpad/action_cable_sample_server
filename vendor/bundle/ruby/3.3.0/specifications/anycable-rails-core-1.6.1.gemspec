# -*- encoding: utf-8 -*-
# stub: anycable-rails-core 1.6.1 ruby lib

Gem::Specification.new do |s|
  s.name = "anycable-rails-core".freeze
  s.version = "1.6.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://github.com/anycable/anycable-rails/issues", "changelog_uri" => "https://github.com/anycable/anycable-rails/blob/master/CHANGELOG.md", "documentation_uri" => "https://docs.anycable.io/#/using_with_rails", "funding_uri" => "https://github.com/sponsors/anycable", "homepage_uri" => "https://anycable.io/", "source_code_uri" => "http://github.com/anycable/anycable-rails" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["palkan".freeze]
  s.date = "2025-12-17"
  s.description = "AnyCable integration for Rails (w/o RPC dependencies)".freeze
  s.email = ["dementiev.vm@gmail.com".freeze]
  s.homepage = "http://github.com/anycable/anycable-rails".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "AnyCable integration for Rails (w/o RPC dependencies)".freeze

  s.installed_by_version = "3.5.16".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<anycable-core>.freeze, ["~> 1.6.0".freeze])
  s.add_runtime_dependency(%q<actioncable>.freeze, [">= 7.0".freeze, "< 9.0".freeze])
  s.add_runtime_dependency(%q<globalid>.freeze, [">= 0".freeze])
end
