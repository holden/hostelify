class Hostelbookers
  
  HB_SINGULAR_URL = "http://www.hostelbookers.com/property/index.cfm?fuseaction=accommodation.search&straccommodationtype=hostels&fromPropertyNameSearch=0"
  HB_PLURAL_URL = "http://www.hostelbookers.com/results/index.cfm?straccommodationtype=hostels&strSearchType=freeText&fuseaction=accommodation.search"
  
  @default_options = { :date => (Date.today+4).to_s, :no_days => "7", :live => true }
  
  def self.find_hostels_by_location(options)
    options = @default_options.merge(options)
    date = Date.strptime(options[:date])
    city = options[:location].split(',').first.rstrip.lstrip.gsub(' ','-').squeeze("-")
    country = options[:location].split(',').last.rstrip.lstrip.gsub(' ','-').squeeze("-")
    
    url = HB_PLURAL_URL + "&strkeywords=#{city},+#{country}&dtearrival=#{date.strftime('%d/%m/%Y')}"
  
    #Retryable.try 3 do
      data = Hpricot(open(url))
    #end
    
    data = data.search("//div[@id='propertyResultsList']")
    
    @results = HostelifyCollection.new

    (data/"tr.propertyRow").each do |row|
      name = row.at("a.propertyTitle").inner_text
      url = row.at("a.propertyTitle")['href']
      desc = row.at("p.shortDescription").inner_text
      rating = row.at("td.rating/text()")
      rating = rating.to_s.to_i unless rating.nil?
      dorm = row.at("td.shared/text()")
      single = row.at("td.private/text()")
      hb_id = url.match(/[\d]{2,5}.$/).to_s.to_i
      
      @results << Hostelify.new(:hostel_id => hb_id, :name => name, :description => desc, :rating => rating, :dorm => dorm, :single => single)
    end    
    return @results
  end

  def self.find_hostel_by_id(options)
    options = @default_options.merge(options)
    date = Date.strptime(options[:date])
    hostel = Hostelify.new
    
    url = HB_SINGULAR_URL + "&intnights=#{options[:no_days]}&intpeople=1&dtearrival=#{date.strftime('%d/%m/%Y')}&intpropertyid=#{options[:id]}"
  
    data = Hpricot(open(url))
    
    hostel.hostel_id = options[:id]
    hostel.name = data.at("h1").inner_text
    hostel.address = data.at("p.address").inner_text
    hostel.description = data.at('div[@id="overviewPane"]').inner_text
    facilities_td = data.at("table.tableFacilities")
    
    facilities = []
    (facilities_td/"td").each do |row|
       facilities << row.inner_text
    end
    hostel.facilities = facilities
    extras = []
    extras_td = data.at("table.tableFeatures")
    (extras_td/"td.name").each do |row|
      extras << "Free " + row.inner_text.to_s
    end
    facilities = facilities + extras
    
    ratings = []
    ratings_td = data.at('div[@id="overviewIndRtng"]')
    
    
    (ratings_td/"dd").each do |row|
      #ratings << row.at("td").inner_text.to_s.to_f
      ratings << row.at('div[@class="ratingPercentage"]').inner_text.to_s.to_f
      #puts row.at('div[@class="ratingPercentage"]')
    end
    
    hostel.ratings = ratings
    images = []
    image = data.at('div[@id="propMedia"]/table')
    (image/"td").each do |row|
      img = row.at("img")['onclick']
      if img =~ /(http).*(jpg|gif|png|jpeg)/
        images << img.match(/(http).*(jpg|gif|png|jpeg)/)[0]
      else
        #add youtube?
      end
    end
    hostel.images = images
    
    if options[:all]
      data = Hpricot(open(url + "&strTab=map"))
      data.search("h2").remove #get rid of header
      hostel.directions = data.at('div[@id="gpsMap"]').inner_text
      hostel.geo = data.to_s.scan(/-{0,1}\d{1,3}\.\d{7}/).uniq!
    end
    
    @availables = []
    available = data.at("div.tableAvailability/table")
    if available
      (available/"tr").each do |row|
        name = row.at("td.roomType/label/text()")
        people = row.at("td.people/select")
        people = people.at("option:last-child").inner_text unless people.nil?
        price = row.at("td.price")
        price = price.inner_text.to_s.match(/[\d.]{1,5}/)[0] unless price.nil?
        (0..(options[:no_days].to_i-1)).each do |x|
          @availables << HostelifyAvailable.new(name,price,people,(date+x).to_s) unless price.nil?
        end
      end

      hostel.availability = @availables
    end
    
    return hostel
  
  
  end

end