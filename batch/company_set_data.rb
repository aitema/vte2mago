require 'rest_client'
require 'nokogiri'
require 'builder'


HOST = "192.168.0.64"


puts "### SOAP Set Data"
xml_request = ""
xml = Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )

xml.instruct! :xml, :version => "1.0"
xml.soap :Envelope,
         "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
         "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
         "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
  xml.soap :Body do
    xml.SetData("xmlns" => "http://microarea.it/TbServices/") {
      xml.authenticationToken "ded5e859-7e9e-4f1f-83c9-f872d23e9ed5"
      xml.useApproximation "true"
      xml.data "<?xml version=\"1.0\"?>
      <maxs:Customers
xmlns:maxs=\"http://www.microarea.it/Schema/2004/Smart/ERP/CustomersSuppliers/Customers/Standard/DefaultLight.xsd\"
tbNamespace=\"Document.ERP.CustomersSuppliers.Documents.Customers\"
xTechProfile=\"DefaultLight\">
        <maxs:Data>
          <maxs:CustomersSuppliers master=\"true\">
            <maxs:CustSuppType>3211264</maxs:CustSuppType>
            <maxs:CompanyName>Aitema 2</maxs:CompanyName>
            <maxs:TaxIdNumber>04147170239</maxs:TaxIdNumber>
          </maxs:CustomersSuppliers>
        </maxs:Data>
      </maxs:Customers>"
    }
  end
end
puts "SOAP REQUEST"
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
puts
puts result.inspect