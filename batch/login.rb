require 'rest_client'
require 'nokogiri'
require 'builder'


HOST = "192.168.0.64"

puts
puts "### SOAP Request Login Compact"

xml_request = ""
xml = Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
xml.instruct! :xml, :version => "1.0"
xml.soap :Envelope,
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.soap :Body do
    xml.LoginCompact("xmlns" => "http://microarea.it/LoginManager/") {
      xml.userName "Utente1"
      xml.companyName "prova"
      xml.overWriteLogin "true"
      xml.password ""
      xml.askingProcess "prova"
    }
  end
end
puts xml_request

response = RestClient.post "http://#{HOST}/MagoNet/LoginManager/LoginManager.asmx", xml_request, :content_type => "text/xml"
#response = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><LoginCompactResponse xmlns=\"http://microarea.it/LoginManager/\"><LoginCompactResult>10</LoginCompactResult><userName>Utente1</userName><companyName>HYPHEN_NET</companyName></LoginCompactResponse></soap:Body></soap:Envelope>"
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
    authenticationToken = subnode.text if subnode.name == 'authenticationToken'
  end
end