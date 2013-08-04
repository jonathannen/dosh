# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dosh'

Gem::Specification.new do |spec|
  spec.name          = "dosh"
  spec.version       = Dosh::VERSION
  spec.authors       = ["Jon Williams"]
  spec.email         = ["jon@jonathannen.com"]
  spec.description   = %q{Dev Ops Scripting}
  spec.summary       = %q{Dev Ops Scripting}
  spec.homepage      = "https://github.com/jonathannen/dosh"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  { 
    'bundler'   => '~> 1.3',
    'rake'      => '>= 10.1.0',
    'rspec'     => '~> 2.14.1',
    'unicorn'   => '>= 4.6.3'
  }.each { |k,v| spec.add_development_dependency(k,v) }

end
