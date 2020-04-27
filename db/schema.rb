# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_27_015657) do

  create_table "articles", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "created_at"], name: "index_articles_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.integer "user_id", null: false
    t.integer "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["created_at"], name: "index_comments_on_created_at"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "likeable_type"
    t.integer "likeable_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "articles", "users"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "users"
end
