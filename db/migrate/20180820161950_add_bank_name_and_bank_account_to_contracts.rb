class AddBankNameAndBankAccountToContracts < ActiveRecord::Migration[5.1]
  def change
    add_column :contracts, :bank_name, :string
    add_column :contracts, :bank_account, :string
  end
end
