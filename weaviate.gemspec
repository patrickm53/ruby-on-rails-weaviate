# frozen_string_literal: true

require_relative "lib/weaviate/version"

Gem::Specification.new do |spec|
  spec.name = "weaviate-ruby"
  spec.version = Weaviate::VERSION
  spec.authors = ["Andrei Bondarev"]
  spec.email = ["andrei@sourcelabs.io", "andrei.bondarev13@gmail.com"]

  spec.summary = "Ruby wrapper for the Weaviate.io API"
  spec.description = "Ruby wrapper for the Weaviate.io API"
  spec.homepage = "https://github.com/andreibondarev/weaviate-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andreibondarev/weaviate-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/andreibondarev/weaviate-ruby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "faraday", ">= 2.0.1", "< 3.0"
  spec.add_dependency "graphlient", ">= 0.7.0", "< 0.9.0"
  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rdiscount" # for github-flavored markdown in yard
end
