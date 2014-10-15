json.array!(@measures) do |measure|
  json.extract! measure, :id, :name, :value, :start_date, :end_date, :unit
  json.url measure_url(measure, format: :json)
end
