class AddDescrizioneLungaItems < ActiveRecord::Migration
  change_table :order_item_requests do |t|
    t.text :descrizione_lunga
  end
end
