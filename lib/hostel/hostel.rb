class Hostel
  attr_accessor :hostel_id, :name, :address, :description, :facilities, :ratings, :directions, :geo, :images, :video, :availability, :price

  def initialize(options = {})
      options.each {
        |k,v|
        self.send( "#{k.to_s}=".intern, v)
      }
    end

end