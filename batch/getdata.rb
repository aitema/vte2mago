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
#puts xml_request



#response = RestClient.post "http://#{HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"

response = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><SetDataResponse xmlns=\"http://microarea.it/TbServices/\"><SetDataResult>true</SetDataResult><result>&lt;?xml version=\"1.0\"?&gt;
&lt;maxs:Customers xmlns:maxs=\"http://www.microarea.it/Schema/2004/Smart/ERP/CustomersSuppliers/Customers/Standard/DefaultLight.xsd\" tbNamespace=\"Document.ERP.CustomersSuppliers.Documents.Customers\" xTechProfile=\"DefaultLight\"&gt;&lt;maxs:Data&gt;&lt;maxs:CustomersSuppliers master=\"true\"&gt;&lt;maxs:CustSuppType&gt;3211264&lt;/maxs:CustSuppType&gt;&lt;maxs:CustSupp&gt;0029&lt;/maxs:CustSupp&gt;&lt;maxs:CompanyName&gt;Aitema 8x&lt;/maxs:CompanyName&gt;&lt;maxs:TaxIdNumber&gt;04147170211&lt;/maxs:TaxIdNumber&gt;&lt;maxs:FiscalCode&gt;&lt;/maxs:FiscalCode&gt;&lt;maxs:Address&gt;&lt;/maxs:Address&gt;&lt;maxs:ZIPCode&gt;&lt;/maxs:ZIPCode&gt;&lt;maxs:City&gt;&lt;/maxs:City&gt;&lt;maxs:County&gt;&lt;/maxs:County&gt;&lt;maxs:Country&gt;&lt;/maxs:Country&gt;&lt;maxs:Telephone1&gt;&lt;/maxs:Telephone1&gt;&lt;maxs:Telephone2&gt;&lt;/maxs:Telephone2&gt;&lt;maxs:Fax&gt;&lt;/maxs:Fax&gt;&lt;maxs:EMail&gt;&lt;/maxs:EMail&gt;&lt;maxs:ISOCountryCode&gt;IT&lt;/maxs:ISOCountryCode&gt;&lt;maxs:ContactPerson&gt;&lt;/maxs:ContactPerson&gt;&lt;maxs:NaturalPerson&gt;false&lt;/maxs:NaturalPerson&gt;&lt;maxs:Payment&gt;&lt;/maxs:Payment&gt;&lt;maxs:Currency&gt;&lt;/maxs:Currency&gt;&lt;maxs:Disabled&gt;false&lt;/maxs:Disabled&gt;&lt;maxs:ExternalCode&gt;&lt;/maxs:ExternalCode&gt;&lt;/maxs:CustomersSuppliers&gt;&lt;maxs:OtherBranches/&gt;&lt;/maxs:Data&gt;&lt;/maxs:Customers&gt;
</result></SetDataResponse></soap:Body></soap:Envelope>"

#puts response.inspect"
getdataresult = ""
get_data_response = Nokogiri::XML::parse response

body = get_data_response.at_xpath("//soap:Body")
body.children.each do |node|
  node.children.each do |subnode|
    puts "--- #{subnode.name}"
    getdataresult = subnode.text if subnode.name == "result"
  end
end

result = Nokogiri::XML::parse getdataresult
puts getdataresult
#getdataresult = maxs.at_xpath("//soap:body").text


#result = ""
#result = maxs.at_xpath("//maxs:Message").text rescue ""
result = result.at_xpath("//maxs:Customers").at_xpath("//maxs:CustSupp").text rescue "NOT PRESENT"
puts result
#puts getdataresult



#puts "-----"
#puts maxs.at_xpath("//maxs:Customers").children
#puts
#puts maxs.at_xpath("//maxs:Code").text rescue ""
#puts maxs.at_xpath("//maxs:Message").text rescue ""
#puts maxs.at_xpath("//maxs:CustSupp").text rescue ""


