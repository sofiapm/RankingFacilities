#Facility 1 e 2 - A e B
Role.seed(:name, :company_name, :nif, :sector, :user_id) do |s|
	s.name = "Facility Manager"
	s.company_name = "Testing Organization 1, Lda"
	s.nif = 123456779
	s.sector = "Telecommunications"
	s.user_id = 1
end

#Facility 3 - C
Role.seed(:name, :company_name, :nif, :sector, :user_id) do |s|
	s.name = "Facility Manager"
	s.company_name = "Testing Organization 2, Lda"
	s.nif = 123456379
	s.sector = "Telecommunications"
	s.user_id = 2
end

#Facility 4
# Role.seed(:name, :company_name, :nif, :sector, :user_id) do |s|
# 	s.name = "Occupant"
# 	s.company_name = "John Doe & Sons, Lda"
# 	s.nif = 123456749
# 	s.sector = "Telecommunications"
# 	s.user_id = 2
# end