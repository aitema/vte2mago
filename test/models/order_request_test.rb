# == Schema Information
#
# Table name: order_requests
#
#  id                  :integer          not null, primary key
#  numero              :string
#  soggetto            :string
#  totale_documento    :float
#  codice_esterno      :string
#  numero_cliente      :string
#  data_ordine_cliente :string
#  numero_offerta      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  descrizione         :text
#  token               :string
#  response            :text
#

require 'test_helper'

class OrderRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
