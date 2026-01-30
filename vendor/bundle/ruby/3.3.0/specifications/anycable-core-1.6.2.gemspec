# -*- encoding: utf-8 -*-
# stub: anycable-core 1.6.2 ruby lib

Gem::Specification.new do |s|
  s.name = "anycable-core".freeze
  s.version = "1.6.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://github.com/anycable/anycable-rb/issues", "changelog_uri" => "https://github.com/anycable/anycable-rb/blob/master/CHANGELOG.md", "documentation_uri" => "https://docs.anycable.io/", "funding_uri" => "https://github.com/sponsors/anycable", "homepage_uri" => "https://anycable.io/", "source_code_uri" => "http://github.com/anycable/anycable-rb" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vladimir Dementyev".freeze]
  s.date = "2025-12-17"
  s.description = "Ruby SDK for AnyCable, an open-source realtime server for reliable two-way communication".freeze
  s.email = ["dementiev.vm@gmail.com".freeze]
  s.executables = ["anycable".freeze, "anycabled".freeze]
  s.files = ["bin/anycable".freeze, "bin/anycabled".freeze]
  s.homepage = "http://github.com/anycable/anycable-rb".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Ruby SDK for AnyCable, an open-source realtime server for reliable two-way communication".freeze

  s.installed_by_version = "3.5.16".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<anyway_config>.freeze, ["~> 2.2".freeze])
  s.add_runtime_dependency(%q<base64>.freeze, [">= 0.2".freeze])
  s.add_runtime_dependency(%q<google-protobuf>.freeze, ["~> 4".freeze])
  s.add_runtime_dependency(%q<stringio>.freeze, ["~> 3".freeze])
  s.add_development_dependency(%q<redis>.freeze, [">= 4.0".freeze])
  s.add_development_dependency(%q<nats-pure>.freeze, ["~> 2".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 13.0".freeze])
  s.add_development_dependency(%q<rack>.freeze, ["~> 3.0".freeze])
  s.add_development_dependency(%q<pry>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, [">= 3.5".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov-lcov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<webmock>.freeze, ["~> 3.8".freeze])
  s.add_development_dependency(%q<webrick>.freeze, [">= 1.9.1".freeze])
end
