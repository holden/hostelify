class Hostelbookers
  
  #constants
  HB_SINGULAR_DETAIL_URL = "http://www.hostelbookers.com/hostels/" #poland/krakow/
  HB_PLURAL_HOSTELS_URL = "http://www.hostelbookers.com/hostels/" #poland/wroclaw/
  HB_DYNAMIC_URL = "http://www.hostelbookers.com/property/index.cfm?fuseaction=accommodation.search&straccommodationtype=hostels"
  #&intnights=2&intpeople=1&dtearrival=21/05/2010&fromPropertyNameSearch=0&intpropertyid=6281
  
  #options
  @default_options = { :date => date=(Date.today+4).to_s, :no_days => "7", :live => true }
  
  def self.find_hostels_by_location(options) #location
    city = options[:location].split(',').first.rstrip.lstrip.gsub(' ','-').squeeze("-")
    country = options[:location].split(',').last.rstrip.lstrip.gsub(' ','-').squeeze("-")

    url = HB_PLURAL_HOSTELS_URL + "#{country}/#{city}"

    
    if options[:date]
      options = @default_options.merge(options)
      date = Date.strptime(options[:date])
      data = setSearch(url,options[:date],options[:no_days])
    else
      Retryable.try 3 do
        data = Hpricot(open(url))
      end
    end
    
    data = data.search("//div[@id='propertyResultsList']")
    #@results = []
    @results = HostelifyCollection.new
      #coder = HTMLEntities.new
    (data/"tr.propertyRow").each do |row|
      name = row.at("a.propertyTitle").inner_text
      url = row.at("a.propertyTitle")['href']
      desc = row.at("p.shortDescription").inner_text
      rating = row.at("td.rating/text()")
      rating = rating.to_s.to_i unless rating.nil?
      dorm = row.at("td.shared/text()")
      single = row.at("td.private/text()")
      hb_id = url.match(/[\d]{2,5}.$/).to_s.to_i
      
      #@results << Hostelify.new(:hostel_id => hb_id, :name => name, :description => desc, :rating => rating, :dorm => dorm, :single => single)
      @results << Hostelify.new(:hostel_id => hb_id, :name => name, :description => desc, :rating => rating, :dorm => dorm, :single => single)
    end    
    return @results
  end
  
  def self.find_hostel_by_id(options)
    #city = options[:location].split(',').first.gsub(' ','')
    #country = options[:location].split(',').last.gsub(' ','')
    id = options[:id]

    #url = HB_SINGULAR_DETAIL_URL + "#{country}/#{city}/#{id}"
    url = HB_DYNAMIC_URL + "&intnights=#{options[:no_days]}&fromPropertyNameSearch=0&intpropertyid=#{options[:id]}"
    
    hostel = Hostelify.new

    if options[:date]
      options = @default_options.merge(options)
    else
      options[:date] = (Date.today+4).to_s
    end
    
    date = Date.strptime(options[:date])
    url2 = HB_DYNAMIC_URL + "&intnights=#{options[:no_days]}&intpeople=1&dtearrival=#{date.strftime('%d/%m/%Y')}&fromPropertyNameSearch=0&intpropertyid=6281"
    data = Hpricot(open(url2))
    #data = setSearch_id(url,options[:date],options[:no_days])
    #url2 = HB_DYNAMIC_URL + "&intnights=#{options[:no_days]}&dtearrival=21/05/2010&fromPropertyNameSearch=0&intpropertyid=#{options[:id]}"

#    else
#      Retryable.try 3 do
#        data = Hpricot(open(url))
#      end
#    end
    
    hostel.hostel_id = id
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
    ratings_td = data.at('div[@id="overviewIndRtng"]/table')
    
    (ratings_td/"tr").each do |row|
      ratings << row.at("td").inner_text.to_s.to_f
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
      data = Hpricot(open(url + "/map"))
      data.search("h2").remove #get rid of header
      hostel.directions = data.at('div[@id="directions"]').inner_text
      hostel.geo = data.to_s.scan(/-{0,1}\d{1,3}\.\d{7}/).uniq!
    end
    
    if options[:date]
      date = Date.strptime(options[:date])
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
            #@availables << { :name => name, :spots => people, :price => price, :bookdate => (date+x).to_s } unless price.nil?
            @availables << HostelifyAvailable.new(name,price,people,(date+x).to_s) unless price.nil?
          end
        end
      end
      hostel.availability = @availables
    end
    
    return hostel
  end
  
  def self.setSearch(url,date,no_days)
      date = Date.strptime(date).strftime("%d/%m/%Y")
      agent = WWW::Mechanize.new
      page = agent.get(url)
      form = page.form_with(:name => 'searchForm') # => WWW::Mechanize::Form
      form.field_with(:name => 'intnights').options[no_days.to_i-1].select
      form.dtearrival = date #d/m/y
      
      Retryable.try 3 do
        page = agent.submit(form)
      end
      
      #to dollars!
      form = page.forms[0]
      form.field_with(:name => 'strSelectedCurrencyCode').options[5].select
      
      Retryable.try 3 do
        page = agent.submit(form)
      end
      
      data = page.search('//div[@id="content"]')

      return data
    end
    
    def self.setSearch_id(url,date,no_days)
        date = Date.strptime(date).strftime("%d/%m/%Y")
        agent = WWW::Mechanize.new
        page = agent.get(url)
        form = page.form_with(:name => 'frmCheckAvailBook') # => WWW::Mechanize::Form
        form.field_with(:name => 'intNights').options[no_days.to_i-1].select
        form.dteArrival = date #d/m/y
        
        Retryable.try 3 do
          page = agent.submit(form)
        end
        #change currency to dollars
        form = page.forms[1]
        #puts form.name
        form.field_with(:name => 'strSelectedCurrencyCode').options[5].select
        
        Retryable.try 3 do
          page = agent.submit(form)
        end
        data = page.search('//div[@id="content"]')

        return data
      end
  
end