require 'hostel'

c=Hostelbookers.find_hostels_by_location(:location => "paris,france")

puts c.last[:desc]