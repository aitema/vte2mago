require 'rest_client'
require 'nokogiri'
require 'builder'


HOST = "192.168.0.64"

puts
puts "### SOAP Get Data Parameters"

xml_parameters = ""
xml = Builder::XmlMarkup.new( :target => xml_parameters, :indent => 2 )
xml.instruct! :xml, :version => "1.0"
xml.maxs :Customers,
         "tbNamespace".to_sym => "Document.ERP.CustomersSuppliers.Documents.CustSupp.Customers",
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.maxs :Parameters do
    xml.maxs :DefaultDialog,
             "title".to_sym => "Ricerca campi" do
      xml.maxs :DefaultGroup,
               "title".to_sym => "Gruppi di ricerca" do
        xml.maxs :CustSupp, "type" => "String" do
          xml.text!("%")
        end
      end
    end
  end
end
puts


puts "### SOAP Get Data"
xml_request = ""
xml = Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )

xml.instruct! :xml, :version => "1.0"
xml.soap :Envelope,
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.soap :Body do
    xml.GetData("xmlns" => "http://microarea.it/TbServices/") {
      xml.authenticationToken "238a99d9-0bb2-4e41-a262-f5e79195d304"
      xml.parameters "<?xml version=\"1.0\"?><maxs:Customers tbNamespace=\"Document.ERP.CustomersSuppliers.Documents.Customers\" xTechProfile=\"DefaultLight\" xmlns:maxs=\"http://www.microarea.it/Schema/2004/Smart/ERP/CustomersSuppliers/Customers/Standard/Default.xsd\"><maxs:Parameters><maxs:DefaultDialog title=\"Ricerca campi\"><maxs:DefaultGroup title=\"Gruppo di ricerca\"><maxs:TaxIdNumber type=\"String\">0838660015</maxs:TaxIdNumber></maxs:DefaultGroup></maxs:DefaultDialog></maxs:Parameters></maxs:Customers>"
    }
  end
end
puts xml_request



response = RestClient.post "http://#{HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"

#puts response.inspect
getdataresult = ""
doc = Nokogiri::XML::parse response
body = doc.at_xpath("//soap:Body")
body.children.each do |node|
  node.children.each do |subnode|
    puts "#{subnode.name} #{subnode.text}"
    getdataresult = subnode.text if subnode.name == 'GetDataResult'
  end
end

result = Nokogiri::XML::parse getdataresult

