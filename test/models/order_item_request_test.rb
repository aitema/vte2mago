# == Schema Information
#
# Table name: order_item_requests
#
#  id               :integer          not null, primary key
#  order_request_id :integer
#  numero_prodotto  :string
#  nome_prodotto    :string
#  descrizione      :text
#  prezzo_unitario  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class OrderItemRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
