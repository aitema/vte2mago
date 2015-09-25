class AddTokenOrders < ActiveRecord::Migration
  change_table :order_requests do |t|
    t.string :token
    t.text :response
  end
end
