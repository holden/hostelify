require 'rubygems'
require 'rake'
require 'echoe'
 
Echoe.new('hostelify', '0.3.6') do |p|
  p.description = "Simple Hostel Webscrapper."
  p.url = "http://github.com/holden/hostelify"
  p.author = "Holden Thomas"
  p.email = "holden.thomas@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end
 
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }