# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ccp/version"

Gem::Specification.new do |s|
  s.name        = "ccp"
  s.version     = Ccp::VERSION
  s.license     = 'MIT'
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

  if RUBY_VERSION >= "1.9"
    s.add_dependency "activesupport"
  else
    s.add_dependency "activesupport", "~> 3.2.0"
  end

  s.add_dependency "typed", ">= 0.2.2"
  s.add_dependency "must", ">= 0.3.0"
  s.add_dependency "dsl_accessor", ">= 0.4.1"
  s.add_dependency "json"
  s.add_dependency "yajl-ruby"
  s.add_dependency "msgpack", "> 0.4"
  s.add_dependency "tokyocabinet", "~> 1.29.1"

  s.add_development_dependency "rspec"
end
