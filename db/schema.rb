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

ActiveRecord::Schema.define(version: 2019_10_17_173513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "highlights", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_uuid", null: false
    t.integer "source_type", default: 0, null: false
    t.string "source_id", null: false
    t.jsonb "source_metadata"
    t.text "source_parent_ids", default: [], array: true
    t.text "anchor", null: false
    t.text "highlighted_content", null: false
    t.text "annotation"
    t.string "color", null: false
    t.text "source_order"
    t.integer "order_in_source"
    t.jsonb "location_strategies", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_parent_ids"], name: "index_highlights_on_source_parent_ids", using: :gin
    t.index ["source_type"], name: "index_highlights_on_source_type"
    t.index ["user_uuid"], name: "index_highlights_on_user_uuid"
  end

end
