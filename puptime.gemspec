# frozen_string_literal: true

require_relative "lib/puptime/version"

Gem::Specification.new do |spec|
  spec.name          = "puptime"
  spec.version       = Puptime::VERSION
  spec.authors       = ["Pavan Vachhani"]
  spec.email         = ["vachhanihpavan@gmail.com"]

  spec.summary       = "IRIS Uptime Monitor"
  spec.description   = "Checks uptime for HTTP, SMTP, DNS and other TCP endpoints"
  spec.homepage      = "https://github.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://github.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com"
  spec.metadata["changelog_uri"] = "https://github.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", "~> 5.2"
  spec.add_runtime_dependency "mail", "~> 2.0"
  spec.add_runtime_dependency "net-ping", "~> 2.0"
  spec.add_runtime_dependency "redis"
  spec.add_runtime_dependency "rufus-scheduler", "~> 3.0"
  spec.add_runtime_dependency "thor", "~> 0.20"
  spec.add_runtime_dependency "typhoeus", "~> 1.4"

  spec.add_development_dependency "rubocop", "~> 0.84"
  spec.add_development_dependency "rubocop-performance", "~> 1.6.0"
end
