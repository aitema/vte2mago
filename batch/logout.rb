require 'rest_client'
require 'nokogiri'
require 'builder'

#406ef624-8417-4bc1-902c-77c773900970
HOST = "192.168.0.64"

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
      xml.authenticationToken "891522e0-929c-4698-967e-5f439d98ccc6"
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