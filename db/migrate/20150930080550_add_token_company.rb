class AddTokenCompany < ActiveRecord::Migration
  change_table :company_requests do |t|
    t.string :token
    t.text :response
  end
end
