# == Schema Information
#
# Table name: order_requests
#
#  id                  :integer          not null, primary key
#  numero              :string(255)
#  soggetto            :string(255)
#  totale_documento    :float(24)
#  codice_esterno      :string(255)
#  numero_cliente      :string(255)
#  data_ordine_cliente :string(255)
#  numero_offerta      :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class OrderRequest < ActiveRecord::Base
  has_many :order_item_requests

  def create_tb
    xml_request = ""
    xml = ::Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
    xml.instruct! :xml, :version => "1.0"
    xml.soap :Envelope,
             "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
             "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
             "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
      xml.soap :Body do
        xml.CreateTB("xmlns" => "http://microarea.it/TbServices/") {
          xml.authenticationToken self.token
          xml.applicationDate Time.now.strftime("%Y-%m-%d")
          xml.checkDate "false"
        }
      end
    end

    response = RestClient.post "http://#{MAGO_HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"


    doc = Nokogiri::XML::parse response
    body = doc.at_xpath("//soap:Body")
    body.children.each do |node|
      node.children.each do |subnode|
        puts "#{subnode.name} #{subnode.text}"
        # La porta Tcp del TBLoader
        createtbresult = subnode.text if subnode.name == 'CreateTBResult'
        # Il token da passare al TBLoader
        easytoken = subnode.text if subnode.name == 'easyToken'
        puts easytoken
      end
    end
  end

  def set_data
    xml_request = ""
    xml = ::Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )

    set_data_xml = "<?xml version=\"1.0\"?>
      <maxs:CustQuota xmlns:maxs=\"http://www.microarea.it/Schema/2004/Smart/ERP/CustomerQuotations/CustQuota/Standard/DefaultLight.xsd\" tbNamespace=\"Document.ERP.CustomerQuotations.Documents.CustQuota\" xTechProfile=\"Default\">
        <maxs:Data>
          <maxs:CustomerQuotation master=\"true\">
            <maxs:QuotationDate>#{Time.now.strftime("%Y-%m-%d")}</maxs:QuotationDate>
            <maxs:Customer>#{self.codice_esterno}</maxs:Customer>
            <maxs:OurReference>#{self.numero}</maxs:OurReference>
            <maxs:Notes>#{self.soggetto}</maxs:Notes>
            <maxs:RequestNo>#{self.numero_cliente}</maxs:RequestNo>
            <maxs:RequestDate>#{self.data_ordine_cliente}</maxs:RequestDate>
          </maxs:CustomerQuotation>
          <maxs:Detail>"
    line = 0
    self.order_item_requests.each do |item|
      line += 1
      set_data_xml += "<maxs:DetailRow>
        <maxs:Line>#{line}</maxs:Line>
        <maxs:LineType>3538947</maxs:LineType>
        <maxs:Description>#{item.nome_prodotto}</maxs:Description>
        <maxs:Item>#{item.numero_prodotto}</maxs:Item>
        <maxs:Qty>1.000000000000000</maxs:Qty>
        <maxs:UnitValue>#{item.prezzo_unitario}</maxs:UnitValue>
        <maxs:Notes>#{item.descrizione}</maxs:Notes>
      </maxs:DetailRow>"
    end

    set_data_xml += "</maxs:Detail>
          <maxs:Notes>
            <maxs:Notes>#{self.descrizione}</maxs:Notes>
          </maxs:Notes>
        </maxs:Data>
      </maxs:CustQuota>"

    #puts set_data_xml


    xml.instruct! :xml, :version => "1.0"
    xml.soap :Envelope,
             "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
             "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
             "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
      xml.soap :Body do
        xml.SetData("xmlns" => "http://microarea.it/TbServices/") {
          xml.authenticationToken self.token
          xml.useApproximation "true"
          xml.data set_data_xml
        }
      end
    end

    puts xml_request
    response = RestClient.post "http://#{MAGO_HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"
    true
  end

  def login
    xml_request = ""
    xml = ::Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
    xml.instruct! :xml, :version => "1.0"
    xml.soap :Envelope,
             "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
             "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
             "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
      xml.soap :Body do
        xml.LoginCompact("xmlns" => "http://microarea.it/LoginManager/") {
          xml.userName MAGO_USERNAME
          xml.companyName MAGO_COMPANY_NAME
          xml.overWriteLogin "true"
          xml.password MAGO_PASSWORD
          xml.askingProcess MAGO_ASKING_PROCESS
        }
      end
    end
    puts MAGO_HOST
    puts xml_request
    response = RestClient.post "http://#{MAGO_HOST}/MagoNet/LoginManager/LoginManager.asmx", xml_request, :content_type => "text/xml"

    authenticationToken = ""
    doc = Nokogiri::XML::parse response
    body = doc.at_xpath("//soap:Body")
    body.children.each do |node|
      node.children.each do |subnode|
        puts "#{subnode.name} #{subnode.text}"
        authenticationToken = subnode.text if subnode.name == 'authenticationToken'
      end
    end
    self.token = authenticationToken
    self.save

  end


  def logout
    xml_request = ""
    xml = ::Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )
    xml.instruct! :xml, :version => "1.0"
    xml.soap :Envelope,
             "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
             "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
             "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
      xml.soap :Body do
        xml.LogOff("xmlns" => "http://microarea.it/LoginManager/") {
          xml.authenticationToken self.token
        }
      end
    end
    puts MAGO_HOST
    puts xml_request
    response = RestClient.post "http://#{MAGO_HOST}/MagoNet/LoginManager/LoginManager.asmx", xml_request, :content_type => "text/xml"

    authenticationToken = ""
    doc = Nokogiri::XML::parse response
    body = doc.at_xpath("//soap:Body")
    body.children.each do |node|
      node.children.each do |subnode|
        puts "#{subnode.name} #{subnode.text}"
      end
    end

  end
end