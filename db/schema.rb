# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150925093158) do

  create_table "company_requests", force: :cascade do |t|
    t.string   "codice_esterno"
    t.string   "ragione_sociale"
    t.string   "id_univoco"
    t.string   "partita_iva"
    t.string   "codice_fiscale"
    t.string   "indirizzo"
    t.string   "città"
    t.string   "codice"
    t.string   "provincia"
    t.string   "regione"
    t.string   "indirizzo_spedizione"
    t.string   "citta_spedizione"
    t.string   "codice_spedizione"
    t.string   "provincia_spedizione"
    t.string   "regione_spedizione"
    t.string   "assegnato_a"
    t.string   "email"
    t.string   "telefono"
    t.string   "fax"
    t.string   "sito_web"
    t.string   "descrizione"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "order_item_requests", force: :cascade do |t|
    t.integer  "order_request_id"
    t.string   "numero_prodotto"
    t.string   "nome_prodotto"
    t.text     "descrizione"
    t.string   "prezzo_unitario"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "order_requests", force: :cascade do |t|
    t.string   "numero"
    t.string   "soggetto"
    t.float    "totale_documento"
    t.string   "codice_esterno"
    t.string   "numero_cliente"
    t.string   "data_ordine_cliente"
    t.string   "numero_offerta"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "descrizione"
    t.string   "token"
    t.text     "response"
  end

end
