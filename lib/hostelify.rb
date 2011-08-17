require 'rubygems'
require 'date'
require 'rest_client'
require 'nibbler'
require 'robotstxt'
require 'hostelify/hostelworld'

module Hostelify
  
  def self.find(*args, &block)
    options = { :currency => 'EUR', :date_from => Date.today+14, :directions => false, :robotstxt_check => false }
    options.merge!(args.pop) if args.last.kind_of? Hash
    
    if options[:robotstxt_check]
      robot_friendly = Robotstxt.allowed?('http://www.hostelworld.com', 'rowbot')
    else
      robot_friendly = true
    end
    
    if robot_friendly
      RestClient.head 'http://www.hostelworld.com/hosteldetails.php/' + options[:id].to_s do |response, request, result|
        redirect = response.headers[:location]
        redirect = redirect + '/directions' if options[:directions]
        date = Date.strptime(options[:date_from].to_s)
        options = {
          :date_from => date+1, 
          :date_to => date+8,
          :searchperformedflag => 1,
          :dynamicSearchFlag => 1,
          :packNo => 0,
          :currency => options[:currency]
        }
      
        RestClient.post redirect, options do |response, request, result|
          @resource = RestClient.get "http://www.hostelworld.com#{response.headers[:location]}", {:cookies => response.cookies}
        end
      end
      
      result = Hostelworld.parse @resource
    end
    

  end  
  
end


