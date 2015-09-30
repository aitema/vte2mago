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

require 'test_helper'

class CompanyRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
