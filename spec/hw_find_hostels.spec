require 'spec/_helper'

describe "finds list of hostels" do
  
  before(:all) do
    @h = Hostelworld.find_hostels_by_location(:location => 'krakow,poland')
  end
  
  it "should get a list with name and brief desc" do
    names = []
    @h.each do |e|
      names << e.name
    end
    names.should include("Mama's Hostel Main Market Square")
  end
  
  
  it "rating should be high for first choices" do
    @h.first.ratings.to_i.should be > 50 
  end
  
  it "desc should have a certain length <" do
    @h.first.description.length.should be > 100 
  end
  
  it "has a hostel number" do
    @h.first.hostel_id.to_i.should_not be nil
  end
  
end

describe "find hostels with dates" do
  
  before(:all) do
    @h = Hostelworld.find_hostels_by_location(:location => 'krakow,poland', :date => (Date.today + 10).to_s)
  end
  
  it "rating should be high for first choices" do
    @h.first.ratings.to_i.should be > 50 
  end
  
  it "desc should have a certain length <" do
    @h.first.description.length.should be > 90
  end
  
  it "has a hostel number" do
    @h.first.hostel_id.to_i.should_not be nil
  end
  
  it "has dorm rooms for greater than $5" do
    @h.first.price.to_i.should be > 5
  end
  
  it "has available rooms!" do
    @h.first.availability.first.should be nil
  end
  
  it "has unavailable rooms!" do
    @h.last.availability.first.should_not be nil
  end
  
end