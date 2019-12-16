
Site.create()

password = 'z81Km$@3rTEp#+2S'
User.create!(
  name:  "Example User",
  outline: "It's an example user account.",
  password:              password,
  password_confirmation: password,
  admin: true
)

if Rails.env.production?
  exit
end

9.times do |n|
  name  = Faker::Name.name
  outline = Faker::Lorem.sentence(20)
  mode = [User::MODE_LOCAL, User::MODE_SITE, User::MODE_WEB].sample
  User.create!(
    name:  name,
    outline: outline,
    password:              password,
    password_confirmation: password,
    mode: mode
  )
end

users = User.all

# tags
tag_names = ["tag0", "tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", nil]

# notes & memos
users.each do |user|

  10.times do
    title = Faker::Book.title
    outline = Faker::Lorem.sentence(20)
    mode = [Note::MODE_LOCAL, Note::MODE_SITE, Note::MODE_WEB].sample
    note = user.notes.create!(
      title: title,
      outline: outline,
      mode: mode
    )

    10.times do |i|
      content = Faker::Lorem.sentence(20)
      note.memos.create!(content: content, number: i+1)
    end

    3.times do
      tag_name = tag_names.sample
      if tag_name
        note.add_tag(tag_name)
      end
    end
  end
end
