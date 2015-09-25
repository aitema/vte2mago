class CreateCompanyRequests < ActiveRecord::Migration
  def change
    create_table :company_requests do |t|
      t.string :codice_esterno
      t.string :ragione_sociale
      t.string :id_univoco
      t.string :partita_iva
      t.string :codice_fiscale
      t.string :indirizzo
      t.string :città
      t.string :codice
      t.string :provincia
      t.string :regione
      t.string :indirizzo_spedizione
      t.string :citta_spedizione
      t.string :codice_spedizione
      t.string :provincia_spedizione
      t.string :regione_spedizione
      t.string :assegnato_a
      t.string :email
      t.string :telefono
      t.string :fax
      t.string :sito_web
      t.string :descrizione


      t.timestamps null: false
    end
  end
end
