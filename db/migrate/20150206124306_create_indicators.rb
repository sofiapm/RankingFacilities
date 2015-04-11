class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :name
      t.float :value
      t.date :date
      t.timestamps
    end
  end
end
