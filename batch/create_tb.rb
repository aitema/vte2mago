require 'rest_client'
require 'nokogiri'
require 'builder'


HOST = "192.168.0.64"

puts
puts "### SOAP CreateTB"
xml_request = ""
xml = Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
xml.instruct! :xml, :version => "1.0"
xml.soap :Envelope,
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.soap :Body do
    xml.CreateTB("xmlns" => "http://microarea.it/TbServices/") {
      xml.authenticationToken "115c25ed-0e1d-4eb2-867a-832b2e1391d6"
      xml.applicationDate Time.now.strftime("%Y-%m-%d")
      xml.checkDate "false"
    }
  end
end
puts xml_request
response = RestClient.post "http://#{HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"
puts
puts
puts "### SOAP Response"
puts "---start---"
puts response.inspect
puts "----end----"

doc = Nokogiri::XML::parse response
body = doc.at_xpath("//soap:Body")
body.children.each do |node|
  node.children.each do |subnode|
    puts "#{subnode.name} #{subnode.text}"
    # La porta Tcp del TBLoader
    createtbresult = subnode.text if subnode.name == 'CreateTBResult'
    # Il token da passare al TBLoader
    easytoken = subnode.text if subnode.name == 'easyToken'
  end
end


