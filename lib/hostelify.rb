require 'rubygems'
require 'date'
require 'rest_client'
require 'nibbler'
require 'hostelify/hostelworld'

module Hostelify
  # Your code goes here...
  
  def self.find(*args, &block)
    options = { :currency => 'EUR', :date_from => '2011-04-06'.to_s }
    options.merge!(args.pop) if args.last.kind_of? Hash
    
    RestClient.head 'http://www.hostelworld.com/hosteldetails.php/20763' do |response, request, result|
      @resource = RestClient.post response.headers[:location], 
        :date_from => Date.strptime(options[:date_from])+1, 
        :date_to => Date.strptime(options[:date_from])+8,
        :searchperformedflag => 1, 
        :currency => options[:currency]
    end

    result = HostelWorld.parse @resource
  end
  
  
end
