class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.string :code
      t.string :receiver
      t.text :notes
      t.date :invoice_date
      t.integer :total
      t.references :client, foreign_key: true
      t.timestamps
    end
    add_index :invoices, :code, unique: true
  end
end
