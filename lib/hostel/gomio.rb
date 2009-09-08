require 'rubygems'
require 'mechanize'
require 'hpricot'
require 'open-uri'
require 'date'
require 'htmlentities'

Hpricot.buffer_size = 262144

class Gomio
    
  #constants
  GOMIO_SINGULAR = "http://www.gomio.com/reservation/chooseBed.aspx?HostelId="
  GOMIO_PLURAL_HOSTELS_URL = "http://www.gomio.com/hostels/europe/" #europe/poland/krakow/mama%27s%20hostel/overview.htm
    
  def self.find_hostel_by_id(options)
    #opts = { :directions => false, :images => false, :all => false }.merge options
    city = options[:location].split(',').first.gsub(' ','')
    country = options[:location].split(',').last.gsub(' ','')
    id = options[:id]
    url = GOMIO_PLURAL_HOSTELS_URL + "#{country}/#{city}/#{id}/overview.htm"
    
    #setSearch(url,"2009-09-20",2,7)
    data = Hpricot(open(url))
    
    data = data.search('div[@id="main"]')
    name = data.at("h3/span").inner_text.lstrip.rstrip
    address = data.at("span.br_address").inner_text.lstrip.rstrip
    desc = data.at("div.br_detail").inner_text.lstrip.rstrip
    available1 = data.at("td.HasNoAvail_Outer")
    available2 = data.at("td.HasNoAvail")
    puts "#{available1}, #{available2}"
  end
  
  def self.find_hostels_by_location(options) #location
    city = options[:location].split(',').first.gsub(' ','')
    country = options[:location].split(',').last.gsub(' ','')
    
    url = GOMIO_PLURAL_HOSTELS_URL + "#{country}/#{city}/search.htm"
    
    #data = Hpricot(open(url))
    data = setSearch(url,"2009-09-09",2,5)
    
    data = data.search("div.SearchResultMembers")
    
    (data/"div.SearchResultsHostel").each do |row|
      name = row.at("h3").inner_text.lstrip.rstrip
      desc = row.at("p").inner_text.lstrip.rstrip
      url = row.at("h3/a")['href']
      gomio_id = url.match(/(#{city}).([\d\D]*)(\/overview.htm)/)[2]
      
      available1 = row/("td.HasNoAvail_Outer/text()").to_a.join(',').split(',')
      available2 = row/("td.HasNoAvail_Outer/text()").to_a.join(',').split(',')
      available = available1 + available2

      @results = { :gomio_id => gomio_id, :name => name, :unavailable => available }
      puts @results
    end
    return @results
  end
  
  def self.setSearch(url,date,no_ppl,no_days)

      date = Date.strptime(date)
      month = date.strftime("%m").to_i
      day = date.strftime("%d").to_i
      if Time.now.strftime("%y") == date.strftime("%y") then year = 0 else year = 1 end

      agent = WWW::Mechanize.new
      page = agent.get(url)

      #the form name
      form = page.forms.first # => WWW::Mechanize::Form
      #page = agent.submit(form)

      #ctl00_searchbox_sb_ddlMonth
      #ctl00_searchbox_sb_ddlDay
      #ctl00_searchbox_sb_ddlYear

      #ctl00_searchbox_sb_ddlNights
      #ctl00_searchbox_sb_ddlBeds

      form.field_with(:name => 'ctl00$searchbox$sb$ddlMonth').options[month-1].select
      form.field_with(:name => 'ctl00$searchbox$sb$ddlDay').options[day-1].select
      form.field_with(:name => 'ctl00$searchbox$sb$ddlYear').options[year].select
      form.field_with(:name => 'ctl00$searchbox$sb$ddlNights').options[no_days.to_i-1].select
      form.field_with(:name => 'ctl00$searchbox$sb$ddlBeds').options[no_ppl.to_i-1].select
      #form.field_with(:id => 'Currency').options[4].select #US Currency

      page = agent.submit(form)
      data = page.search('//div[@id="main"]')
      #puts data
      return data
    end
    
  #url = GOMIO_PLURAL_HOSTELS_URL + "poland/krakow/search.htm"
  
  #Gomio.setSearch(url,"2009-09-20",2,7)
  Gomio.find_hostels_by_location(:location => "krakow,poland")
  #Gomio.find_hostel_by_id(:id => "mama's%20hostel", :location => "krakow,poland")
  
end