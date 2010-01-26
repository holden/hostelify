#delete

class Hostelify
  attr_accessor :hostel_id, :name, :address, :description, :facilities, :ratings, :directions, :geo, :images, :video, :availability
  attr_accessor :rating, :dorm, :single, :unavailable, :genre

  def initialize(options = {})
      options.each {
        |k,v|
        self.send( "#{k.to_s}=".intern, v)
      }
  end

end

class HostelifyCollection < Array
  # This collection does everything an Array does, plus
  # you can add utility methods like names.

  def ids
    collect do |i|
      i.hostel_id
    end
  end
  
  def names
    collect do |i|
      i.name
    end
  end
  
  def descs
    collect do |i|
      i.description
    end
  end
  
end

class HostelifyAvailable
  attr_accessor :name, :price, :spots, :bookdate
  
  def initialize(name, price, spots, bookdate)
    @name = name
    @price = price
    @spots = spots
    @bookdate = bookdate
  end
  
end

module Retryable
  extend self

  def try times = 1, options = {}, &block
    val = yield
  rescue options[:on] || Exception
    retry if (times -= 1) > 0
  else
    val
  end
end

