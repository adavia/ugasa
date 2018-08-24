class RemoveZoneFromClients < ActiveRecord::Migration[5.1]
  def change
    remove_column :clients, :zone, :string
    add_reference :clients, :location, foreign_key: { to_table: :locations }
  end
end
