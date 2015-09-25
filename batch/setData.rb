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
      xml.authenticationToken "115c25ed-0e1d-4eb2-867a-832b2e1391d6"
      xml.useApproximation "true"
      xml.data "<?xml version=\"1.0\"?>
<maxs:CustQuota xmlns:maxs=\"http://www.microarea.it/Schema/2004/Smart/ERP/CustomerQuotations/CustQuota/Standard/DefaultLight.xsd\" tbNamespace=\"Document.ERP.CustomerQuotations.Documents.CustQuota\" xTechProfile=\"Default\">
  <maxs:Data>
    <maxs:CustomerQuotation master=\"true\">
      <maxs:QuotationDate>2015-09-24</maxs:QuotationDate>
      <maxs:Customer>0001</maxs:Customer>
      <maxs:OurReference>xxxxxxx</maxs:OurReference>
      <maxs:Notes>Soggetto offerta</maxs:Notes>
      <maxs:RequestNo>yyyyyy</maxs:RequestNo>
      <maxs:RequestDate>2015-09-20</maxs:RequestDate>
    </maxs:CustomerQuotation>
    <maxs:Detail>
      <maxs:DetailRow>
        <maxs:Line>1</maxs:Line>
        <maxs:LineType>3538947</maxs:LineType>
        <maxs:Description>articolo unooooo</maxs:Description>
        <maxs:Item>A1</maxs:Item>
        <maxs:Qty>1.000000000000000</maxs:Qty>
        <maxs:UnitValue>100.000000000000000</maxs:UnitValue>
        <maxs:Notes>iu1209eu0219ue0912u0w9u12093u1209u09wu1209uw1290 uw0921u w09u12w90u1209wu1290u</maxs:Notes>
      </maxs:DetailRow>
      <maxs:DetailRow>
        <maxs:Line>2</maxs:Line>
        <maxs:LineType>3538947</maxs:LineType>
        <maxs:Description>articolo dueeeee</maxs:Description>
        <maxs:Item>A1</maxs:Item>
        <maxs:UoM>NR</maxs:UoM>
        <maxs:Qty>1.000000000000000</maxs:Qty>
        <maxs:UnitValue>330.000000000000000</maxs:UnitValue>
      </maxs:DetailRow>
    </maxs:Detail>
    <maxs:Notes>
      <maxs:Notes>hasldhaskljdhaskljdhas lkdhais</maxs:Notes>
    </maxs:Notes>
  </maxs:Data>
</maxs:CustQuota>"
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
puts
puts result.inspect