class Items
  @items = []
  class << self
    attr_accessor :items
  end
  attr_accessor :name, :description
  #def self.each(&args)
  #  @items.each(&args)
  #end
  def initialize(name, description)
    @name, @description = name, description
    Items.items << self
  end
  def each(&block)
    yield name
    yield description
  end
  
  def self.names
    puts "hello"
  end
  
end
