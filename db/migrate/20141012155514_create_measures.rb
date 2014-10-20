class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :name, null: false
      t.float :value, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :unit, null: false

      t.timestamps
    end
  end
end
