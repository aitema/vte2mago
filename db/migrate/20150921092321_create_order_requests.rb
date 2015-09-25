class CreateOrderRequests < ActiveRecord::Migration
  def change
    create_table :order_requests do |t|
      t.string :numero
      t.string :soggetto
      t.float  :totale_documento
      t.string :codice_esterno
      t.string :numero_cliente
      t.string :data_ordine_cliente
      t.string :numero_offerta
      t.timestamps null: false
    end
  end
end
