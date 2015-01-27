class GranularMeasure < ActiveRecord::Base
	belongs_to :measure, class_name: 'Measure', foreign_key: 'measure_id'

	validates :day, presence: true
	validates :value, presence: true
end
