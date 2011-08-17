# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hostelify/version"

Gem::Specification.new do |s|
  s.name        = "hostelify"
  s.version     = Hostelify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Holden Thomas"]
  s.email       = ["holden@wombie.com"]
  s.homepage    = "http://wombie.com"
  s.summary     = %q{API for hostel related sites}
  s.description = %q{scrapper for publicly accessible data from hostelworld hostelbookers etc.}
  
  s.add_dependency('rest-client', '>= 1.6.1')
  s.add_dependency('nokogiri', '>= 1.4.4')
  s.add_dependency('nibbler', '>= 1.2.1')
  s.add_dependency('robotstxt', '>= 0.5.4')
  #s.add_development_dependency('rspec', '2.6.0')

  s.rubyforge_project = "hostelify"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
