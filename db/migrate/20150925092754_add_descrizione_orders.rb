class AddDescrizioneOrders < ActiveRecord::Migration
  change_table :order_requests do |t|
    t.text :descrizione
  end
end
