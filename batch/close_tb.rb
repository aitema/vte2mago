require 'rest_client'
require 'nokogiri'
require 'builder'


HOST = "192.168.1.199"



puts
puts "### SOAP CloseTB request"
xml_request = ""
xml = Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
xml.instruct! :xml, :version => "1.0"
xml.soap :Envelope,
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.soap :Body do
    xml.CloseTB("xmlns" => "http://microarea.it/TbServices/") {
      xml.authenticationToken "236ac7fc-4d33-4e75-9381-a43fe1398e7d"
    }
  end
end
puts xml_request
response = RestClient.post "http://#{HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"
puts
puts "### SOAP Response"
puts response.inspect