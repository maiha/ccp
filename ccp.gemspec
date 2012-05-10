# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ccp/version"

Gem::Specification.new do |s|
  s.name        = "ccp"
  s.version     = Ccp::VERSION
  s.authors     = ["maiha"]
  s.email       = ["maiha@wota.jp"]
  s.homepage    = "http://github.com/maiha/ccp"
  s.summary     = %q{A Ruby library for Composite Command Programming}
  s.description = %q{CCP}

  s.rubyforge_project = "ccp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "typed", ">= 0.2.2"
  s.add_dependency "must", ">= 0.2.7"
  s.add_dependency "dsl_accessor", ">= 0.4.1"

  s.add_development_dependency "rspec"
end
