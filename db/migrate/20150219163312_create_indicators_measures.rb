class CreateIndicatorsMeasures < ActiveRecord::Migration
  def change
  	create_table :indicators_measures, id: false do |t|
      t.belongs_to :indicators, index: true
      t.belongs_to :measures, index: true
  	end
  end
end
