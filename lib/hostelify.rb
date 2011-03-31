require 'rubygems'
require 'date'
require 'rest_client'
require 'nibbler'
require 'hostelify/hostelworld'

module Hostelify
  
  def self.find(*args, &block)
    options = { :currency => 'EUR', :date_from => (Date.today+14).to_s, :directions => false }
    options.merge!(args.pop) if args.last.kind_of? Hash
    
    RestClient.head 'http://www.hostelworld.com/hosteldetails.php/' + options[:id].to_s do |response, request, result|
      redirect = response.headers[:location]
      redirect = redirect + '/directions' if options[:directions]
      
      @resource = RestClient.post redirect, 
        :date_from => Date.strptime(options[:date_from])+1, 
        :date_to => Date.strptime(options[:date_from])+8,
        :searchperformedflag => 1, 
        :currency => options[:currency]
    end

    result = HostelWorld.parse @resource
  end
  
  
end
