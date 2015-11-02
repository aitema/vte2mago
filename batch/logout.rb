require 'rest_client'
require 'nokogiri'
require 'builder'


HOST = "192.168.0.71"

puts "### SOAP Request Logoff"
xml_request = ""
xml = Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
xml.instruct! :xml, :version => "1.0"
xml.soap :Envelope,
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.soap :Body do
    xml.LogOff("xmlns" => "http://microarea.it/LoginManager/") {
      xml.authenticationToken "d3569c14-45de-4aa0-8c73-e961da94420c"
    }
  end
end

response = RestClient.post "http://#{HOST}/MagoNet/LoginManager/LoginManager.asmx", xml_request, :content_type => "text/xml"
puts
puts "### SOAP Response"
puts "---start---"
puts response
puts "----end----"

authenticationToken = ""
doc = Nokogiri::XML::parse response
body = doc.at_xpath("//soap:Body")
body.children.each do |node|
  node.children.each do |subnode|
    puts "#{subnode.name} #{subnode.text}"
  end
end