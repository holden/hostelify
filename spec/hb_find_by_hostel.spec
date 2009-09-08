$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'hostel'

describe "should find individual hostel and get object with name etc." do
  
  before(:all) do
    @h = Hostelbookers.find_hostel_by_id(:location => "krakow,poland", :id => 9330)
    @h = Hostelbookers.find_hostel_by_id(:location => "lviv,ukraine", :id => 19606)
  end
  
  it "should query hostelbookers and return the correct name" do
    @h.name.should match(/^.*(Hostel).*$/)
  end
  
  it "address" do
	  @h.address.should match(/^.*(Krakow|Lviv).*$/)
	end
	
	it "description" do
	  @h.address.should_not be nil
	end
	
	it "facilities" do
	  @h.should have_at_least(8).facilities
	end
	
	it "ratings" do
	  @h.should have(8).ratings
	end
	
	it "images at least 6" do
	  @h.should have_at_least(6).images
	end

end

describe "all options" do
  before(:all) do
    @h = Hostelbookers.find_hostel_by_id(:location => "krakow,poland", :id => 9330, :all => true)
  end
  
  it "directions should have a certain length <" do
    @h.directions.length.should be > 25
  end
  
  it "geo" do
	  @h.geo[0].to_f.round.should eql 50
	end
end

describe "with dates to get availabilty and verify output!" do
  before(:all) do
    @h = Hostelbookers.find_hostel_by_id(:location => "krakow,poland", :id => 19831, :date => (Date.today+10).to_s)
  end
  
  it "get first availability and check it merit" do
    @h.availability.first[:name] =~ /bed/
  end
  
  it "check number of avail beds" do
    @h.availability.first[:spots].to_i.should be > 1
  end
  
  it "last avail has a price > 5 US" do
    @h.availability.last[:price].to_i.should be > 5
  end
  
  it "book date eq today + 10" do
    @h.availability.last[:bookdate].should_not be nil
  end
  

end
