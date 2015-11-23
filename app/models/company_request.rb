# == Schema Information
#
# Table name: company_requests
#
#  id                   :integer          not null, primary key
#  codice_esterno       :string
#  ragione_sociale      :string
#  id_univoco           :string
#  partita_iva          :string
#  codice_fiscale       :string
#  indirizzo            :string
#  città                :string
#  codice               :string
#  provincia            :string
#  regione              :string
#  indirizzo_spedizione :string
#  citta_spedizione     :string
#  codice_spedizione    :string
#  provincia_spedizione :string
#  regione_spedizione   :string
#  assegnato_a          :string
#  email                :string
#  telefono             :string
#  fax                  :string
#  sito_web             :string
#  descrizione          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class CompanyRequest < ActiveRecord::Base

  def read_data
    xml_request = ""
    xml = ::Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )

    get_data_xml = "<?xml version=\"1.0\"?>
        <maxs:Customers tbNamespace=\"Document.ERP.CustomersSuppliers.Documents.Customers\" xTechProfile=\"Default\" xmlns:maxs=\"http://www.microarea.it/Schema/2004/Smart/ERP/CustomersSuppliers/Customers/Standard/Default.xsd\">
            <maxs:Parameters>
                <maxs:DefaultDialog title=\"Ricerca campi\">
                    <maxs:DefaultGroup title=\"Gruppo di ricerca\">
                        <maxs:CustSuppType type=\"DataEnum\">3211264</maxs:CustSuppType>
                         <maxs:TaxIdNumber type=\"String\">#{self.partita_iva}</maxs:TaxIdNumber>
                     </maxs:DefaultGroup>
                </maxs:DefaultDialog>
            </maxs:Parameters>
        </maxs:Customers>"

    #puts "SOAP REQUEST -------"
    #puts get_data_xml.inspect

    xml.instruct! :xml, :version => "1.0"
    xml.soap :Envelope,
             "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
             "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
             "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
      xml.soap :Body do
        xml.GetData("xmlns" => "http://microarea.it/TbServices/") {
          xml.authenticationToken self.token
          xml.useApproximation "true"
          xml.parameters get_data_xml
        }
      end
    end

    response = RestClient.post "http://#{MAGO_HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"

    #puts "SOAP RESPONSE -------"
    #puts response.inspect

    maxs = Nokogiri::XML::parse response

    get_data_result = ""
    body = maxs.at_xpath("//soap:Body")
    body.children.each do |node|
      node.children.each do |subnode|
        #puts subnode.name
        get_data_result = subnode.text if subnode.name == "GetDataResult"
      end
    end

    result = Nokogiri::XML::parse get_data_result
    code = result.at_xpath("//maxs:Customers").at_xpath("//maxs:CustSupp").text rescue "NOT PRESENT"
    puts code
    code
  end


  def set_data
    xml_request = ""
    xml = ::Builder::XmlMarkup.new( :target => xml_request, :indent => 2 )

    # assegnato a
    # indirizzo spedizione

    xml.instruct! :xml, :version => "1.0"
    xml.soap :Envelope,
             "xmlns:xsi".to_sym => "http://www.w3.org/2001/XMLSchema-instance",
             "xmlns:xsd".to_sym => "http://www.w3.org/2001/XMLSchema",
             "xmlns:soap".to_sym => "http://schemas.xmlsoap.org/soap/envelope/" do
      xml.soap :Body do
        xml.SetData("xmlns" => "http://microarea.it/TbServices/") {
          xml.authenticationToken self.token
          xml.useApproximation "true"
          xml.data "<?xml version=\"1.0\"?>
      <maxs:Customers
xmlns:maxs=\"http://www.microarea.it/Schema/2004/Smart/ERP/CustomersSuppliers/Customers/Standard/Default.xsd\"
tbNamespace=\"Document.ERP.CustomersSuppliers.Documents.Customers\"
xTechProfile=\"Default\">
        <maxs:Data>
          <maxs:CustomersSuppliers master=\"true\">
            <maxs:CustSuppType>3211264</maxs:CustSuppType>
            <maxs:CompanyName>#{self.ragione_sociale}x</maxs:CompanyName>
            <maxs:ExternalCode>#{self.id_univoco}</maxs:ExternalCode>
            <maxs:TaxIdNumber>#{self.partita_iva}</maxs:TaxIdNumber>
            <maxs:FiscalCode>#{self.codice_fiscale}</maxs:FiscalCode>
            <maxs:Address>#{self.indirizzo}</maxs:Address>
            <maxs:ZIPCode>#{self.codice}</maxs:ZIPCode>
            <maxs:City>#{self.città}</maxs:City>
            <maxs:County>#{self.provincia}</maxs:County>
            <maxs:Region>#{self.regione}</maxs:Region>
            <maxs:Telephone1>#{self.telefono}</maxs:Telephone1>
            <maxs:Fax>#{self.fax}</maxs:Fax>
            <maxs:EMail>#{self.email}</maxs:EMail>
            <maxs:Internet>#{self.sito_web}</maxs:Internet>
            <maxs:Notes>#{self.descrizione}</maxs:Notes>
          </maxs:CustomersSuppliers>
          <maxs:OtherBranches>
            <maxs:OtherBranchesRow>
              <maxs:CustSuppType>3211264</maxs:CustSuppType>
              <maxs:Branch>01</maxs:Branch>
              <maxs:Address>#{self.indirizzo_spedizione}</maxs:Address>
              <maxs:ZIPCode>#{self.codice_spedizione}</maxs:ZIPCode>
              <maxs:City>#{self.citta_spedizione}</maxs:City>
              <maxs:County>#{self.provincia_spedizione}</maxs:County>
              <maxs:Region>#{self.regione_spedizione}</maxs:Region>
            </maxs:OtherBranchesRow>
          </maxs:OtherBranches>
          <maxs:Options>
            <maxs:CustSuppType>3211264</maxs:CustSuppType>
            <maxs:Salesperson>#{self.assegnato_a}</maxs:Salesperson>
          </maxs:Options>
        </maxs:Data>
      </maxs:Customers>"
        }
      end
    end

    puts xml_request

    response = RestClient.post "http://#{MAGO_HOST}/MagoNet/TbServices/TbServices.asmx", xml_request, :content_type => "text/xml"

    puts "RESPONSE ---- "
    puts response

    maxs = Nokogiri::XML::parse response

    set_data_result = ""
    body = maxs.at_xpath("//soap:Body")
    body.children.each do |node|
      node.children.each do |subnode|
        #puts subnode.name
        set_data_result = subnode.text if subnode.name == "result"
      end
    end

    result = Nokogiri::XML::parse set_data_result
    code = result.at_xpath("//maxs:Customers").at_xpath("//maxs:CustSupp").text rescue "NOT PRESENT"
    puts code
    code

  end

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

        createtbresult = subnode.text if subnode.name == 'CreateTBResult'
        # Il token da passare al TBLoader
        easytoken = subnode.text if subnode.name == 'easyToken'
        puts easytoken
      end
    end
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
    response = RestClient.post "http://#{MAGO_HOST}/MagoNet/LoginManager/LoginManager.asmx", xml_request, :content_type => "text/xml"

    authenticationToken = ""
    loginCompactResult = ""
    doc = Nokogiri::XML::parse response
    body = doc.at_xpath("//soap:Body")
    body.children.each do |node|
      node.children.each do |subnode|
        puts "#{subnode.name} #{subnode.text}"
        authenticationToken = subnode.text if subnode.name == 'authenticationToken'
        loginCompactResult = subnode.text if subnode.name == 'LoginCompactResult'
      end
    end
    self.token = authenticationToken
    self.save
    loginCompactResult
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
