# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hostelify}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Holden Thomas"]
  s.date = %q{2009-09-21}
  s.description = %q{Simple Hostel Webscrapper.}
  s.email = %q{holden.thomas@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/hostelify.rb", "lib/hostelify/gomio.rb", "lib/hostelify/hostelbookers.rb", "lib/hostelify/hostelify.rb", "lib/hostelify/hostelworld.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "hostelify.gemspec", "lib/hostelify.rb", "lib/hostelify/gomio.rb", "lib/hostelify/hostelbookers.rb", "lib/hostelify/hostelify.rb", "lib/hostelify/hostelworld.rb", "pkg/hostelify-0.2.8.gem", "pkg/hostelify-0.2.8.tar.gz", "pkg/hostelify-0.2.8/Manifest", "pkg/hostelify-0.2.8/README.rdoc", "pkg/hostelify-0.2.8/Rakefile", "pkg/hostelify-0.2.8/hostelify.gemspec", "pkg/hostelify-0.2.8/lib/hostelify.rb", "pkg/hostelify-0.2.8/lib/hostelify/gomio.rb", "pkg/hostelify-0.2.8/lib/hostelify/hostelbookers.rb", "pkg/hostelify-0.2.8/lib/hostelify/hostelify.rb", "pkg/hostelify-0.2.8/lib/hostelify/hostelworld.rb", "pkg/hostelify-0.2.8/spec/_helper.rb", "pkg/hostelify-0.2.8/spec/hb_find_by_hostel.spec", "pkg/hostelify-0.2.8/spec/hb_find_hostels.spec", "pkg/hostelify-0.2.8/spec/hw_find_by_hostel.spec", "pkg/hostelify-0.2.8/spec/hw_find_hostels.spec", "spec/_helper.rb", "spec/hb_find_by_hostel.spec", "spec/hb_find_hostels.spec", "spec/hw_find_by_hostel.spec", "spec/hw_find_hostels.spec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/holden/hostelify}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Hostelify", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{hostelify}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple Hostel Webscrapper.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
