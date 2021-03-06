# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191217093937) do

  create_table "memos", force: :cascade do |t|
    t.text "content"
    t.integer "number"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id", "number"], name: "index_memos_on_note_id_and_number"
    t.index ["note_id"], name: "index_memos_on_note_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.text "outline"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mode", default: 0
    t.string "picture"
    t.index ["user_id", "updated_at"], name: "index_notes_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "picture"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "outline"
    t.index ["note_id"], name: "index_pictures_on_note_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name", default: "Memolet"
    t.integer "mode", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tagships", force: :cascade do |t|
    t.integer "note_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id", "tag_id"], name: "index_tagships_on_note_id_and_tag_id", unique: true
    t.index ["note_id"], name: "index_tagships_on_note_id"
    t.index ["tag_id"], name: "index_tagships_on_tag_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.text "outline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.integer "mode", default: 0
    t.string "picture"
    t.boolean "admin_en", default: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
