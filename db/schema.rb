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
    t.string   "codice_esterno",       limit: 255
    t.string   "ragione_sociale",      limit: 255
    t.string   "id_univoco",           limit: 255
    t.string   "partita_iva",          limit: 255
    t.string   "codice_fiscale",       limit: 255
    t.string   "indirizzo",            limit: 255
    t.string   "città",                limit: 255
    t.string   "codice",               limit: 255
    t.string   "provincia",            limit: 255
    t.string   "regione",              limit: 255
    t.string   "indirizzo_spedizione", limit: 255
    t.string   "citta_spedizione",     limit: 255
    t.string   "codice_spedizione",    limit: 255
    t.string   "provincia_spedizione", limit: 255
    t.string   "regione_spedizione",   limit: 255
    t.string   "assegnato_a",          limit: 255
    t.string   "email",                limit: 255
    t.string   "telefono",             limit: 255
    t.string   "fax",                  limit: 255
    t.string   "sito_web",             limit: 255
    t.string   "descrizione",          limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "order_item_requests", force: :cascade do |t|
    t.integer  "order_request_id", limit: 4
    t.string   "numero_prodotto",  limit: 255
    t.string   "nome_prodotto",    limit: 255
    t.text     "descrizione",      limit: 65535
    t.string   "prezzo_unitario",  limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "order_requests", force: :cascade do |t|
    t.string   "numero",              limit: 255
    t.string   "soggetto",            limit: 255
    t.float    "totale_documento",    limit: 24
    t.string   "codice_esterno",      limit: 255
    t.string   "numero_cliente",      limit: 255
    t.string   "data_ordine_cliente", limit: 255
    t.string   "numero_offerta",      limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "descrizione",         limit: 65535
    t.string   "token",               limit: 255
    t.text     "response",            limit: 65535
  end

end
