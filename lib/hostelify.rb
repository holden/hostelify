require 'rubygems'
require 'rest_client'
require 'nibbler'
require 'hostelify/hostelworld'

module Hostelify
  # Your code goes here...
  
  def self.find
    resource = RestClient.post 'http://www.hostelworld.com/hosteldetails.php/The-Kosmonaut-Hostel/Lviv/20763', 
      :date_from => '04 Apr 2011', 
      :date_to => '10 Apr 2011', 
      :searchperformedflag => 1, 
      :currency => 'EUR'

    result = HostelWorld.parse resource
  end
  
  
end
