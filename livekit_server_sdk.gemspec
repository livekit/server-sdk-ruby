# frozen_string_literal: true

require_relative "lib/livekit/version"

Gem::Specification.new do |spec|
  spec.name = "livekit-server-sdk"
  spec.version = LiveKit::VERSION
  spec.authors = ["Omri Gabay", "David Zhao"]
  spec.email = ["omri@omrigabay.me", "dz@livekit.io"]

  spec.summary = "LiveKit Server SDK for Ruby"
  spec.homepage = "https://livekit.io"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "google-protobuf", "~> 3.21.0"
  spec.add_dependency "jwt", ">= 2.2.3", "< 3.0"
  spec.add_dependency "twirp", "~> 1.9.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
