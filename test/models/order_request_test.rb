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

require 'test_helper'

class OrderRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
