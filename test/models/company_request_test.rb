# == Schema Information
#
# Table name: company_requests
#
#  id                   :integer          not null, primary key
#  codice_esterno       :string(255)
#  ragione_sociale      :string(255)
#  id_univoco           :string(255)
#  partita_iva          :string(255)
#  codice_fiscale       :string(255)
#  indirizzo            :string(255)
#  città                :string(255)
#  codice               :string(255)
#  provincia            :string(255)
#  regione              :string(255)
#  indirizzo_spedizione :string(255)
#  citta_spedizione     :string(255)
#  codice_spedizione    :string(255)
#  provincia_spedizione :string(255)
#  regione_spedizione   :string(255)
#  assegnato_a          :string(255)
#  email                :string(255)
#  telefono             :string(255)
#  fax                  :string(255)
#  sito_web             :string(255)
#  descrizione          :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'test_helper'

class CompanyRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
