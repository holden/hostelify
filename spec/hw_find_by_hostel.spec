require 'spec/_helper'

describe "find hostel by id, no options" do
  
  before(:all) do
    @h = Hostelworld.find_hostel_by_id(:id => 7113)
    @h = Hostelworld.find_hostel_by_id(:id => 20763)
  end
    
  it "should query hostelworld and return the correct name" do
	  @h.name.should match(/^.*(Hostel).*$/)
	end
	
	it "address" do
	  @h.address.should match(/^.*(Krakow|Lviv).*$/)
	end
	
	it "description" do
	  @h.address.should_not be nil
	end
	
	it "facilities" do
	  @h.should have_at_least(15).facilities
	end
	
	it "ratings" do
	  @h.should have(6).ratings
	end
			
end

describe "youtube" do
  
  before(:all) do
    @h3 = Hostelworld.find_hostel_by_id(:id => 7113)
  end
  
  it "video" do
	  @h3.video.should match(/^.*(youtube.com).*$/)
	end
end

describe "find hostel with all options" do
  before(:all) do
	  @h2 = Hostelworld.find_hostel_by_id(:id => 7113, :all => true)
	  @h2 = Hostelworld.find_hostel_by_id(:id => 20763, :all => true)
	end
	
	it "geo" do
	  @h2.geo[0].to_f.round.should eql 50
	end
	
	it "directions" do
	  @h2.directions.should_not be nil
	end
	
	it "images at least 6" do
	  @h2.should have_at_least(6).images
	end
end

describe "with dates to get availabilty and verify output!" do
  before(:all) do
    @h = Hostelworld.find_hostel_by_id(:id => 20763, :date => (Date.today+20).to_s)
  end
  
  it "get first availability and check it merit" do
    @h.availability.first.name =~ /bed/
  end
  
  it "check number of avail beds" do
    @h.availability.first.spots.to_i.should be >= 1
  end
  
  it "last avail has a price > 5 US" do
    @h.availability.first.price.to_i.should be > 5
  end
  
  it "book date eq today + 10" do
    @h.availability.last.bookdate.should_not be nil
  end
  

end
