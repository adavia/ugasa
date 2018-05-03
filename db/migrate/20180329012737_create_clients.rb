class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :rfc
      t.string :social_name
      t.string :legal_representative
      t.string :comercial_name
      t.string :responsible
      t.string :phone
      t.string :zone
      t.integer :invoices_count, default: 0
      t.integer :total_oil_sum, default: 0

      t.timestamps
    end
  end
end
