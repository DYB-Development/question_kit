# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_11_003347) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "easy_flow_definitions", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "start_label"
    t.string "status", default: "active", null: false
    t.string "persists", default: "unsaved", null: false
    t.json "document"
    t.integer "definition_cursor"
    t.json "changes_since_version"
    t.json "undo_history"
    t.json "undone_changes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "host", null: false
    t.string "owner_type"
    t.integer "owner_id"
    t.string "public_code", null: false
    t.index ["host", "owner_type", "owner_id", "slug"], name: "index_easy_flow_definitions_on_host_owner_and_slug", unique: true, where: "owner_id IS NOT NULL"
    t.index ["host", "slug"], name: "index_easy_flow_definitions_on_host_and_slug", unique: true, where: "owner_id IS NULL"
    t.index ["public_code"], name: "index_easy_flow_definitions_on_public_code", unique: true
  end

  create_table "easy_flow_runs", force: :cascade do |t|
    t.integer "flow_id", null: false
    t.integer "definition_version_id", null: false
    t.string "owner_type"
    t.integer "owner_id"
    t.json "recorded"
    t.string "label"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_run_id"
    t.string "parent_step"
    t.string "public_code", null: false
    t.index ["definition_version_id"], name: "index_easy_flow_runs_on_definition_version_id"
    t.index ["flow_id"], name: "index_easy_flow_runs_on_flow_id"
    t.index ["owner_type", "owner_id"], name: "index_easy_flow_runs_on_owner"
    t.index ["parent_run_id"], name: "index_easy_flow_runs_on_parent_run_id"
    t.index ["public_code"], name: "index_easy_flow_runs_on_public_code", unique: true
  end

  create_table "easy_flow_versions", force: :cascade do |t|
    t.integer "flow_id", null: false
    t.integer "number", null: false
    t.json "definition"
    t.json "changes_captured"
    t.string "status", default: "draft", null: false
    t.datetime "created_at", null: false
    t.string "public_code", null: false
    t.index ["flow_id", "number"], name: "index_easy_flow_versions_on_flow_id_and_number", unique: true
    t.index ["flow_id"], name: "index_easy_flow_versions_on_flow_id"
    t.index ["flow_id"], name: "index_easy_flow_versions_on_one_live_per_flow", unique: true, where: "status = 'live'"
    t.index ["public_code"], name: "index_easy_flow_versions_on_public_code", unique: true
  end

  create_table "ixport_export_templates", force: :cascade do |t|
    t.string "key", null: false
    t.string "name", null: false
    t.json "columns", null: false
    t.string "person_type", null: false
    t.integer "person_id", null: false
    t.string "account_type"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_type", "account_id"], name: "index_ixport_export_templates_on_account"
    t.index ["person_type", "person_id"], name: "index_ixport_export_templates_on_person"
  end

  create_table "ixport_import_refusals", force: :cascade do |t|
    t.integer "import_id", null: false
    t.integer "row_number", null: false
    t.text "reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id"], name: "index_ixport_import_refusals_on_import_id"
  end

  create_table "ixport_imports", force: :cascade do |t|
    t.string "key", null: false
    t.string "person_type", null: false
    t.integer "person_id", null: false
    t.string "account_type"
    t.integer "account_id"
    t.json "mapping"
    t.string "status", default: "pending", null: false
    t.integer "added_count", default: 0, null: false
    t.integer "updated_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "wallflower_task_id"
    t.text "error_message"
    t.string "target_type"
    t.integer "target_id"
    t.index ["account_type", "account_id"], name: "index_ixport_imports_on_account"
    t.index ["person_type", "person_id"], name: "index_ixport_imports_on_person"
    t.index ["target_type", "target_id"], name: "index_ixport_imports_on_target"
    t.index ["wallflower_task_id"], name: "index_ixport_imports_on_wallflower_task_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "easy_flow_runs", "easy_flow_definitions", column: "flow_id"
  add_foreign_key "easy_flow_runs", "easy_flow_runs", column: "parent_run_id"
  add_foreign_key "easy_flow_runs", "easy_flow_versions", column: "definition_version_id"
  add_foreign_key "easy_flow_versions", "easy_flow_definitions", column: "flow_id"
  add_foreign_key "ixport_import_refusals", "ixport_imports", column: "import_id"
end
