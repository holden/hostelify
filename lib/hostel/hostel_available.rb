class HostelAvailable
  attr_accessor :name, :price, :spots, :bookdate
  
  def initialize(name, price, spots, bookdate)
    @name = name
    @price = price
    @spots = spots
    @bookdate = bookdate
  end
  
end