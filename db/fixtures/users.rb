#User 1
User.seed(:first_name, :last_name, :email, :encrypted_password, :address_id) do |s|
	s.first_name = "Jane"
	s.last_name = "Doe"
	s.email = "jane.doe@gmail.com"
	s.encrypted_password = "$2a$10$zuVX7iN6Bn.g9fI.5LJYpeHgG7bZbRpt5avy0YM1rDLlF8fHDfeMu"
	s.address_id = 1
end

#User 2
User.seed(:first_name, :last_name, :email, :encrypted_password, :address_id) do |s|
	s.first_name = "John"
	s.last_name = "Doe"
	s.email = "john.doe@gmail.com"
	s.encrypted_password = "$2a$10$zuVX7iN6Bn.g9fI.5LJYpeHgG7bZbRpt5avy0YM1rDLlF8fHDfeMu"
	s.address_id = 4
end