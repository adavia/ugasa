class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :file
      t.references :attacheable, polymorphic: true

      t.timestamps
    end
  end
end
