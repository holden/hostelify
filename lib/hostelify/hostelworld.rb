class HostelWorld < Nibbler
  element 'h1' => :name, :with => lambda { |node| node.inner_text.lstrip.rstrip }
  element '.street-city' => :address, :with => lambda { |node| node.inner_text.gsub(/\s{6,}.*/,'').chop.lstrip }
  element 'div.row //p[5]' => :content
  element 'div#directions p' => :directions, :with => lambda { |node| node.inner_text.gsub(/(DIRECTIONS):.*$/,'').lstrip }
  elements '//script[14]' => :geo, :with => lambda { |node| node.inner_text.scan(/-{0,1}\d{1,3}\.\d{7}/).uniq! }
  elements 'div.links ul.column li' => :features, :with => lambda { |node| node.inner_text.first }
  elements '.cboxElement img //@src' => :photos
  elements '.rating-values li' => :ratings
  elements '.beds-details tr' => :rooms do
    element 'td[1]' => :title, :with => lambda { |node| node.inner_text }
    element 'td[2]' => :price
  end
  
  elements '//table[@class="beds-details"]//tr[position() > 1]' => :beds do
    element 'td.left span' => :title, :with => lambda { |node| node.inner_text.lstrip.rstrip }
    elements 'td[@style="cursor: help"]' => :nights do
      element '.currency' => :price
      element '@title' => :spots, :with => lambda { |node| node.inner_text.match(/\d{1,}$/) }
    end
  end
end