class Hostel
  attr_accessor :hostel_id, :name, :address, :description, :facilities, :ratings, :directions, :geo, :images, :video, :availability
  
  def facilities
     self.instance_variable_get(:@facilities) || []
  end

  #def ratings
  #   self.instance_variable_get(:@ratings) || []
  #end

  #def photos
  #  self.instance_variable_get(:@photos) || []
  #end

end