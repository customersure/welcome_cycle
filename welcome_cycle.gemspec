# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "welcome_cycle/version"

Gem::Specification.new do |s|
  s.name        = "welcome_cycle"
  s.version     = WelcomeCycle::VERSION
  s.authors     = ["Luke Brown", "Chris Stainthorpe"]
  s.email       = ["tsdbrown@gmail.com", "skipchris@randomcat.com"]
  s.homepage    = ""
  s.summary     = %q{Welcome cycle code for SAAS apps}
  s.description = %q{The idea behind this gem is to abstract out the logic of sending out welcome emails during a free trial.}

  s.rubyforge_project = "welcome_cycle"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency(%q<rails>, [">= 3.0.10"])

  s.add_development_dependency "rspec"
end
