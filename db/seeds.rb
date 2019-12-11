
Site.create()

password = 'z81Km$@3rTEp#+2S'
User.create!(
  name:  "Example User",
  outline: "It's an example user account.",
  password:              password,
  password_confirmation: password,
  admin: true
)

 exit

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
["tag1", "tag2", "tag3", "tag4", "tag5"].each do |name|
  Tag.create(name: name)
end
tag_ids = []
Tag.order(:created_at).each do |tag|
  tag_ids.append(tag.id)
end
tag_ids.append(nil)

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

    1.times do
      tag_id = tag_ids.sample
      if tag_id
        Tagship.create!(note_id: note.id, tag_id: tag_id)
      end
    end
  end
end
