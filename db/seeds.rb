password = 'z81Km$@3rTEp#+2S'

User.create!(name:  "Example User",
             password:              password,
             password_confirmation: password,
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  User.create!(name:  name,
               password:              password,
               password_confirmation: password)
end