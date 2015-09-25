class CreateOrderItemRequests < ActiveRecord::Migration
  def change
    create_table :order_item_requests do |t|
      t.references :order_request
      t.string :numero_prodotto
      t.string :nome_prodotto
      t.text :descrizione
      t.string :prezzo_unitario
      t.timestamps null: false
    end
  end
end
