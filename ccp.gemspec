# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ccp/version', __FILE__)

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
    s.add_runtime_dependency "activesupport"
  else
    s.add_runtime_dependency "activesupport", "~> 3.2.0"
  end

  s.add_runtime_dependency "typed", ">= 0.2.2"
  s.add_runtime_dependency "must", ">= 0.3.0"
  s.add_runtime_dependency "dsl_accessor", ">= 0.4.1"
  s.add_runtime_dependency "json"


  if RUBY_PLATFORM == 'java'
    s.platform = RUBY_PLATFORM
    s.add_runtime_dependency "msgpack-jruby", "~> 1.3.2"
  else
    s.add_runtime_dependency "yajl-ruby"
    s.add_runtime_dependency 'msgpack', '> 0.4'
    s.add_runtime_dependency "tokyocabinet", "~> 1.29.1"
  end

  ### test

  s.add_development_dependency "rspec"
  if defined?(JRUBY_VERSION)
    s.add_runtime_dependency 'kyotocabinet-java'
  else
    s.add_development_dependency "tokyocabinet", "~> 1.29.1"
    s.add_development_dependency "kyotocabinet-ruby", "~> 1.27.1"
  end
end
