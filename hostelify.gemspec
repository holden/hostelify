# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hostelify}
  s.version = "0.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Holden Thomas"]
  s.date = %q{2010-01-26}
  s.description = %q{Simple Hostel Webscrapper.}
  s.email = %q{holden.thomas@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/hostel.rb", "lib/hostel/gomio.rb", "lib/hostel/hostel.rb", "lib/hostel/hostel_available.rb", "lib/hostel/hostelbookers.rb", "lib/hostel/hostelworld.rb", "lib/hostelify.rb", "lib/hostelify/gomio.rb", "lib/hostelify/hostel.rb", "lib/hostelify/hostelbookers.rb", "lib/hostelify/hostelify.rb", "lib/hostelify/hostelworld.rb", "lib/hostelify/hostelworldmonkey.rb", "lib/items.rb", "lib/test.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "hostelify.gemspec", "lib/hostel.rb", "lib/hostel/gomio.rb", "lib/hostel/hostel.rb", "lib/hostel/hostel_available.rb", "lib/hostel/hostelbookers.rb", "lib/hostel/hostelworld.rb", "lib/hostelify.rb", "lib/hostelify/gomio.rb", "lib/hostelify/hostel.rb", "lib/hostelify/hostelbookers.rb", "lib/hostelify/hostelify.rb", "lib/hostelify/hostelworld.rb", "lib/hostelify/hostelworldmonkey.rb", "lib/items.rb", "lib/test.rb", "spec/_helper.rb", "spec/hb_find_by_hostel.spec", "spec/hb_find_hostels.spec", "spec/helper.rb", "spec/hw_find_by_hostel.spec", "spec/hw_find_hostels.spec"]
  s.homepage = %q{http://github.com/holden/hostelify}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Hostelify", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{hostelify}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple Hostel Webscrapper.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
