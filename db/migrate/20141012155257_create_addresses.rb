class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street, null: false, unique: true
      t.string :city, null: false
      t.string :country, null: false
      t.integer :zip_code, null: false, precision: 4

      t.timestamps
    end
  end
end
