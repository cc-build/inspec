lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "inspec-bin/version"

# This is just link inspec-bin, but relies on inspec-core instead of inspec
# inspec-core is a stripped-down version of the inspec gem with fewer exotic dependencies

Gem::Specification.new do |spec|
  spec.name          = "cinc-auditor-core-bin" # dallas multi-pass
  spec.version       = InspecBin::VERSION
  spec.authors       = ["Chef InSpec Core Engineering", "Cinc Project"]
  spec.email         = ["inspec@chef.io", "maintainers@cinc.sh"]
  spec.summary       = "Infrastructure and compliance testing."
  spec.description   = "Cinc Auditor (a community distribution of InSpec) executable for inspec-core gem."
  spec.homepage      = "https://gitlab.com/cinc-project/auditor"
  spec.license       = "Apache-2.0"

  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "inspec-core", "= #{InspecBin::VERSION}"
  spec.add_development_dependency "rake"

  spec.files = %w{README.md LICENSE Gemfile} + ["cinc-auditor-core-bin.gemspec"] +
    Dir.glob("{lib,bin}/**/*", File::FNM_DOTMATCH).reject { |f| File.directory?(f) }

  spec.bindir = "bin"
  spec.executables = %w{cinc-auditor}

end
