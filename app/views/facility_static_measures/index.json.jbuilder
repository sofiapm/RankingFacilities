json.array!(@facility_static_measures) do |facility_static_measure|
  json.extract! facility_static_measure, :id, :name, :value, :start_date, :end_date, :facility_id, :user_id
  json.url facility_static_measure_url(facility_static_measure, format: :json)
end
