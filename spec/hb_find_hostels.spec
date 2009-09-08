$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'hostel'

describe "test hostelbookers hostel listings" do
  
  before(:all) do
    @h = Hostelbookers.find_hostels_by_location(:location => "krakow,poland")
  end
  
  it "should return a list of names" do
    names = []
    @h.each do |e|
      names << e[:name]
    end
    names.should include("Flamingo Hostel")
    names.should include("Mama's Hostel- Main Market Square")
  end
  
  it "rating should be high for first choices" do
    @h.first[:rating].to_i.should be > 50 
  end
  
  it "desc should have a certain length <" do
    @h.first[:desc].length.should be > 100 
  end
  
  it "has a hostel number" do
    @h.first[:hostel_id].to_i.should_not be nil
  end
  
end