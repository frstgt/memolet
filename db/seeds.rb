password = 'z81Km$@3rTEp#+2S'

User.create!(
  name:  "Example User",
  outline: "It's an example user account.",
  password:              password,
  password_confirmation: password,
  admin: true
)

9.times do |n|
  name  = Faker::Name.name
  outline = Faker::Lorem.sentence(20)
  User.create!(
    name:  name,
    outline: outline,
    password:              password,
    password_confirmation: password
  )
end

users = User.all

# notes & memos
users.each do |user|

  3.times do
    title = Faker::Book.title
    outline = Faker::Lorem.sentence(20)
    note = user.notes.create!(
      title: title,
      outline: outline
    )

    10.times do |i|
      content = Faker::Lorem.sentence(20)
      note.memos.create!(content: content, number: i+1)
    end
  end
end
