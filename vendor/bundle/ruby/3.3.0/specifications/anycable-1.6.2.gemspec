# -*- encoding: utf-8 -*-
# stub: anycable 1.6.2 ruby lib

Gem::Specification.new do |s|
  s.name = "anycable".freeze
  s.version = "1.6.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://github.com/anycable/anycable-rb/issues", "changelog_uri" => "https://github.com/anycable/anycable-rb/blob/master/CHANGELOG.md", "documentation_uri" => "https://docs.anycable.io/", "funding_uri" => "https://github.com/sponsors/anycable", "homepage_uri" => "https://anycable.io/", "source_code_uri" => "http://github.com/anycable/anycable-rb" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vladimir Dementyev".freeze]
  s.date = "2025-12-17"
  s.description = "Ruby SDK for AnyCable, an open-source realtime server for reliable two-way communication".freeze
  s.email = ["dementiev.vm@gmail.com".freeze]
  s.homepage = "http://github.com/anycable/anycable-rb".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Ruby SDK for AnyCable, an open-source realtime server for reliable two-way communication".freeze

  s.installed_by_version = "3.5.16".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<anycable-core>.freeze, ["= 1.6.2".freeze])
  s.add_runtime_dependency(%q<grpc>.freeze, ["~> 1.6".freeze])
end
