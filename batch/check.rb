require 'rest_client'
require 'nokogiri'
require 'builder'


HOST = "192.168.1.199"

puts
puts "### SOAP Request Login Compact"

#file = "LoginCompact.xml"
#xml_request = File.read(file)

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
      xml.companyName "HYPHEN_NET"
      xml.overWriteLogin "false"
      xml.password ""
      xml.askingProcess "hyphen_net"
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
  puts "---elements-"
  puts authenticationToken
end






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
      xml.authenticationToken authenticationToken
    }
  end
end
puts xml_request
response = RestClient.post "http://#{HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"
puts
puts "### SOAP Response"
puts response.inspect

# memorizza la porta
# memorizza il token del TB


# xml get parameters (paramtetri e profilo xtech) lezione 4

# Get data ritorna array di stringhe che riporta documento uno per stringa

#set data postingAcion 0 insert 1 update

puts "### SOAP CloseTB"
xml_request = ""
xml = Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
xml.instruct! :xml, :version => "1.0"
xml.soap :Envelope,
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.soap :Body do
    xml.CloseTB("xmlns" => "http://microarea.it/TbServices/") {
      xml.authenticationToken authenticationToken
    }
  end
end
puts xml_request
response = RestClient.post "http://#{HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"
puts
puts "### SOAP Response"
puts response.inspect


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
      xml.authenticationToken authenticationToken
    }
  end
end

response = RestClient.post "http://#{HOST}/MagoNet/LoginManager/LoginManager.asmx", xml_request, :content_type => "text/xml"
puts
puts "### SOAP Response"
puts response.inspect