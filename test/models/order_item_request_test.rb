# == Schema Information
#
# Table name: order_item_requests
#
#  id               :integer          not null, primary key
#  order_request_id :integer
#  numero_prodotto  :string(255)
#  nome_prodotto    :string(255)
#  descrizione      :text(65535)
#  prezzo_unitario  :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class OrderItemRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
