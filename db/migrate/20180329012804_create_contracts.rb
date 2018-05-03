class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.decimal :oil_payment, precision: 16, scale: 2
      t.date :contract_date
      t.date :contract_end
      t.string :contact
      t.string :address
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
