
#Role 1 - User 1
Facility.seed(:name, :address_id, :role_id, :user_id) do |s|
	s.name = "Facility A"
	s.address_id = 2
	s.role_id = 1
	s.user_id = 1
end

#Role 1 - User 1
Facility.seed(:name, :address_id, :role_id, :user_id) do |s|
	s.name = "Facility B"
	s.address_id = 3
	s.role_id = 1
	s.user_id = 1
end

#Role 1 - User 2
Facility.seed(:name, :address_id, :role_id, :user_id) do |s|
	s.name = "Facility C"
	s.address_id = 5
	s.role_id = 2
	s.user_id = 2
end

#Role 1 - User 2
# Facility.seed(:name, :address_id, :role_id, :user_id) do |s|
# 	s.name = "Facility 4"
# 	s.address_id = 6
# 	s.role_id = 3
# 	s.user_id = 2
# end