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

ActiveRecord::Schema[7.1].define(version: 2024_07_03_092906) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "user_name"
    t.string "email"
    t.string "password_digest"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "otp"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "location"
    t.string "unique_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_code"
    t.string "amount_paid"
    t.date "date"
    t.date "date_registered"
    t.serial "sequence_number"
    t.boolean "bag_confirmed", default: false
    t.boolean "confirm_request", default: false
    t.datetime "confirmation_date"
    t.datetime "request_date"
    t.string "otp"
  end

  create_table "general_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "location_name"
    t.string "sub_location"
    t.string "location_code"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "payment_code"
    t.string "phone_number"
    t.string "name"
    t.string "amount_paid"
    t.string "total"
    t.string "remaining_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prefix_and_digits", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id"
  end

  create_table "prefix_and_digits_for_service_providers", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id"
  end

  create_table "prefix_and_digits_for_store_managers", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id"
  end

  create_table "prefix_and_digits_for_stores", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id"
  end

  create_table "prefixes", force: :cascade do |t|
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_providers", force: :cascade do |t|
    t.string "phone_number"
    t.string "name"
    t.string "email"
    t.string "provider_code"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_registered"
    t.serial "sequence_number"
    t.datetime "date_collected"
    t.datetime "date_delivered"
    t.boolean "delivered", default: false
    t.boolean "collected", default: false
    t.string "otp"
    t.string "location"
  end

  create_table "store_managers", force: :cascade do |t|
    t.string "number_of_bags_received"
    t.datetime "date_reeived"
    t.string "number_of_bags_delivered"
    t.datetime "date_delivered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "store_number"
    t.datetime "date_registered"
    t.datetime "date_received"
    t.serial "sequence_number"
    t.string "manager_number"
    t.string "otp"
  end

  create_table "stores", force: :cascade do |t|
    t.string "amount_of_bags"
    t.string "status"
    t.boolean "from_store"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "store_number"
    t.serial "sequence_number"
    t.string "sub_location"
  end

  create_table "sub_locations", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "created_by"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
