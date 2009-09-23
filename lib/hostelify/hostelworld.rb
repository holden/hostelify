class Hostelworld
    
  #constants
  #location list includes/indexjs.js
  HW_SINGULAR_DETAIL_URL = "http://www.hostelworld.com/hosteldetails.php?HostelNumber="
  HW_SINGULAR_IMAGE_URL = "http://www.hostelworld.com/hostelpictures.php?HostelNumber="
  HW_SINGULAR_AVAILABILITY = "http://www.hostelworld.com/availability.php/"
  HW_SINGULAR_YOUTUBE_URL = "http://www.hostelworld.com/youtubevideo.php?HostelNumber="
  HW_PLURAL_HOSTELS_URL = "http://www.hostelworld.com/findabed.php/"
  
  #options
  @default_options = { :date => date=(Date.today+4).to_s, :no_days => "7", :no_ppl => "2" }
  
  def self.parse_html(url)
    f = open(url)
    f.rewind
    Retryable.try 3 do
      data = Hpricot(Iconv.conv('utf-8', f.charset, f.readlines.join("\n")))
    end
  end
  
  def self.find_hostel_by_id(options)
    opts = { :directions => false, :images => false, :all => false }.merge options
    id = options[:id].to_s
    url = HW_SINGULAR_DETAIL_URL + id
    
    #coder = HTMLEntities.new
    hostel = Hostelify.new
    hostel.hostel_id = id
    
    if options[:date]
      options = @default_options.merge(options)
      date = Date.strptime(options[:date])
      data = setSearch(url, options[:date], options[:no_ppl], options[:no_days])
    else
      data = parse_html(url)
    end
    
    unless data == "Full" 
      data = data.search("//div[@id='content']")
      data.search("h3").remove #get rid of header
    
      #title, address, desc, facilities, ratings
      hostel.name = data.at("h2").inner_text.gsub(/( in  ).*$/,'')
      hostel.address = data.at('div[@style="padding-top: 5px"]').inner_text.lstrip
    
      if options[:date]
        hostel.availability = parse_availables(data)
      else
        hostel.description = data.at('div[@id="microDescription2]').inner_text
      end
    
      #optional
      no_photos = data.at('div[@id="microPicScroll"]/span/a').inner_text.to_i
      #no_photos = data.at('span/a[@id="picLink"]').inner_text.to_i
      video = data.at('div[@id="microVideo"]')
    
      facilities = []
      (data/"li.microFacilitiesBoomLi").each do |item|
        facilities << item.inner_text
      end
    
      ratings = []
      (data/'div[@id="ratingsBar2"]').each do |item|
        ratings << item.inner_text.to_i
      end
    
      hostel.facilities = facilities
      hostel.ratings = ratings
    
      if video #exists
        data = parse_html(HW_SINGULAR_YOUTUBE_URL + id)
        video_url = data.at('param[@name="movie"]')['value']
        hostel.video = video_url
        #video_url = data.at('tag')
      end
    
      if options[:directions] or options[:all]
        data = parse_html(HW_SINGULAR_DETAIL_URL + id + "/directions/")
    
        #directions, geo
        hostel.directions = data.at('div[@id="content"]').inner_text.gsub(/^[\d\D\n]*(DIRECTIONS)/,'')
        hostel.geo = data.to_s.scan(/-{0,1}\d{1,3}\.\d{7}/).uniq!
      end

      if no_photos and (options[:images] or options[:all])
        images = []
        (1..no_photos).each do |i|
          data = parse_html(HW_SINGULAR_IMAGE_URL + id + '&PicNO=' + i.to_s)
          images << (data/"img").first[:src].to_s
        end
        hostel.images = images
      end
    else
      hostel = nil
    end
    hostel # return
  end
  
  def self.find_hostels_by_location(options) #location
    
    city = options[:location].split(',').first.gsub(' ','')
    country = options[:location].split(',').last.gsub(' ','')
    url = HW_PLURAL_HOSTELS_URL + "ChosenCity.#{city}/ChosenCountry.#{country}"
    
    if options[:date]
      options = @default_options.merge(options)
      date = Date.strptime(options[:date])
      data = setSearch2(url, options[:date], options[:no_ppl], options[:no_days])
    else
      data = parse_html(url)
    end
    
    data = data.search("//div[@id='content']")
    @results = HostelifyCollection.new

    (data/"div.hostelListing").each do |row|
      name = row.at("h3").inner_text
      desc = row.at("div.hostelEntry/p").inner_text.to_s.chop.gsub('more info','').squeeze('.')
      url = row.at("h3/a")['href']
      rating = row.at("h4/text()")
      rating = rating.to_s.to_i unless rating.nil?
      type = row.at("div.hostelListingImage/span").inner_text
      hostel_id = url.match(/[\d]*$/).to_s
      
      if options[:date]
        #price_USD = row.at("span.blueBeds").inner_text #need to fix float
        dorm = (row.at("p.hostelListingRate/span.blueBeds/text()")).to_s.gsub(/[A-Z$]*/,'')
        single = row.at("p.hostelListingPrivateRate/span.blueBeds/text()").to_s.gsub(/[A-Z$]*/,'')
        available = row/"ul.hostelListingDates/li.noAvail/text()"
        available = available.to_a.join(',').split(',')
        @results << Hostelify.new(:hostel_id => hostel_id, :name => name, :description => desc, :rating => rating, :dorm => dorm, :single => single, :unavailable => available)
      else
        @results << Hostelify.new(:hostel_id => hostel_id, :name => name, :description => desc, :rating => rating)
      end
    end
    return @results
  end
  
  private
  
  def self.setSearch(url,date,no_ppl,no_days)

      date = Date.strptime(date)
      month = date.strftime("%m").to_i
      day = date.strftime("%d").to_i
      if Time.now.strftime("%y") == date.strftime("%y") then year = 0 else year = 1 end

      agent = WWW::Mechanize.new
      page = agent.get(url)

      #the form name
      #form = page.forms.first # => WWW::Mechanize::Form
      form = page.form_with(:name => 'theForm')
      
      #page = agent.submit(form)
      
      #form must be submitted twice because the people writing hostelworld are retards
      #form = page.forms.first # => WWW::Mechanize::Form
      #form = page.form_with(:name => 'theForm')
      form.field_with(:name => 'selMonth2').options[month-1].select
      form.field_with(:name => 'selDay2').options[day-1].select
      form.field_with(:name => 'selYear2').options[year].select
      #form.field_with(:name => { 0 => 'NumNights' }).options[no_days.to_i-1].select
      my_fields = form.fields.select {|f| f.name == "NumNights"}
      my_fields[1].value = no_days.to_i
      #form.my_fields[1].whatever = "value"
      #form.field_with(:name => 'Persons').options[no_ppl.to_i-1].select
      #form.field_with(:name => 'Currency').options[4].select #US Currency
      

      Retryable.try 3 do
        page = agent.submit(form, form.button_with(:name => 'DateSelect'))
      end
      
      error = page.search("div.microBookingError2")

      if error.to_s.length > 1
        data = "Full"
      else
        data = page.search("//div[@id='content']")
      end
      
      return data
    end
    
    def self.setSearch2(url,date,no_ppl,no_days)

        date = Date.strptime(date)
        month = date.strftime("%m").to_i
        day = date.strftime("%d").to_i
        if Time.now.strftime("%y") == date.strftime("%y") then year = 0 else year = 1 end

        agent = WWW::Mechanize.new
        page = agent.get(url)

        #the form name
        #form = page.forms.first # => WWW::Mechanize::Form
        form = page.form_with(:name => 'theForm')

        #page = agent.submit(form)

        #form must be submitted twice because the people writing hostelworld are retards

        form.field_with(:name => 'selMonth').options[month-1].select
        form.field_with(:name => 'selDay').options[day-1].select
        form.field_with(:name => 'selYear').options[year].select
        form.field_with(:name => 'NumNights').options[no_days.to_i-1].select
        form.field_with(:name => 'Persons').options[no_ppl.to_i-1].select
        form.field_with(:name => 'Currency').options[4].select #US Currency

        Retryable.try 3 do
          page = agent.submit(form)
        end
        data = page.search("//div[@id='content']")
        return data
      end
    
    def self.parse_availables(info)
      
      availability = info.at('table[@id="tableDatesSelected2"]')
      availability.search("div").remove
      availability.search("span.hwRoomTypeDesc").remove
      
      availables = []
      
      (availability/"tr").each do |row|
        name = (row/"td").first
        name = name.inner_text unless name.nil?
        
        (row/"td").each do |td|
          night = td.attributes['title']
          if night
            price = night.to_s.match(/([\d]{1,3}).([\d]{2})/).to_s
            available = night.to_s.match(/(available: )([\d]*)/)
            date = night.to_s.match(/(Date: ).*$/).to_s.gsub(/(Date: )|(th)|(nd)|(rd)|(st)/,'')
            date = Date.strptime(date, "%a %d %b '%y")

            if available
              beds = available.to_s.match(/[\d]{1,2}/)[0]
              availables << HostelifyAvailable.new(name,price,beds,date)
            else
              availables << HostelifyAvailable.new(name,price,0,date)
            end
          end
        end
      end
      return availables
      
    end
    
  
end