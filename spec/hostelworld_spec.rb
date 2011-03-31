require "spec_helper"

describe "hostelworld" do
  
  before(:each) do
    @hostel = Hostelify.find(:id => 20763, :date_from => Date.today+14)
    #@hostel = Hostelify.find(:id => 7113)
  end
  
  it "should return a name containing the word hostel" do
    @hostel.name.should match(/^.*(Hostel).*$/)
  end

  
end