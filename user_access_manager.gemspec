require_relative 'lib/user_access_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "user_access_manager"
  spec.version       = UserAccessManager::VERSION
  spec.authors       = ["MijanurR"]
  spec.email         = ["sk.mijanur.rahaman@mettletech.in"]

  spec.summary       = %q{TODO: Write a short summary, because RubyGems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/MijanurR/user_access_manager"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency 'jsonpath', '~> 1.0', '>= 1.0.6'
end
