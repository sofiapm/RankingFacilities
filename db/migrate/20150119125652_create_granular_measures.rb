class CreateGranularMeasures < ActiveRecord::Migration
  def change
    create_table :granular_measures do |t|
      t.float :value, null: false, :precision => 2
      t.date :day, null: false
      t.integer :measure_id, null: false
      t.timestamps
    end
  end
end
