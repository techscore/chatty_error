# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chatty_error/version'

Gem::Specification.new do |spec|
  spec.name          = "chatty_error"
  spec.version       = ChattyError::VERSION
  spec.authors       = ["Kentaro Kawano"]
  spec.email         = ["kawano.kentaro@synergy101.jp"]
  spec.description   = %q{'chatty_error' helps you create error with message easily. An error message is loaded from i18n locale file.}
  spec.summary       = %q{'chatty_error' helps you create error with message easily.}
  spec.homepage      = ""
  spec.license       = "The BSD 3-Clause License"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "i18n"
  spec.add_development_dependency "rspec"
end
