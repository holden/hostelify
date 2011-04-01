require "spec_helper"

describe "hostelworld" do
  
  before(:all) do
    @hostel = Hostelify.find(:id => 20763, :date_from => Date.today+14)
    #@hostel = Hostelify.find(:id => 7113)
  end
  
  it "should return a name containing the word hostel" do
    @hostel.name.should match(/^.*(Hostel).*$/)
  end

  it "should have a description of at least 300 chars" do
  	  @hostel.content.should_not be nil
  end
  
  it "should have at least 4 images" do
	  @hostel.should have_at_least(6).photos
	end
	
	it "should have one available spot" do
	  @hostel.beds.last.nights.last.spots.to_i.should be >= 1
	end
  
  it "should have a price above $5" do
    @hostel.beds.last.nights.last.price.to_i.should be >= 5
  end
  
end