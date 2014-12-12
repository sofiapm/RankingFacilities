class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :company_name, null: false
      t.integer :nif, null: false, unique: true, precision: 9
      t.string :sector, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
