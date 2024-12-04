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

ActiveRecord::Schema[7.1].define(version: 2024_12_02_161058) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "admin_settings", force: :cascade do |t|
    t.boolean "login_with_otp"
    t.boolean "login_with_web_auth"
    t.boolean "login_with_otp_email"
    t.boolean "send_password_via_sms"
    t.boolean "send_password_via_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "check_inactive_days"
    t.string "check_inactive_hrs"
    t.boolean "check_is_inactive"
    t.boolean "enable_2fa_for_admin"
    t.boolean "check_is_inactivehrs"
    t.boolean "check_is_inactiveminutes"
    t.string "check_inactive_minutes"
    t.boolean "enable_2fa_for_admin_passkeys"
    t.integer "account_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "user_name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "otp"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "role", default: 0
    t.boolean "can_read_payment"
    t.boolean "can_manage_payment"
    t.boolean "can_manage_settings"
    t.boolean "can_read_settings"
    t.boolean "can_read_customers"
    t.boolean "can_manage_customers"
    t.boolean "can_manage_service_provider"
    t.boolean "can_read_service_provider"
    t.boolean "can_manage_store"
    t.boolean "can_read_store"
    t.boolean "can_manage_store_manager"
    t.boolean "can_read_store_manager"
    t.boolean "can_manage_location"
    t.boolean "can_read_location"
    t.boolean "can_manage_sub_location"
    t.boolean "can_read_sub_location"
    t.boolean "can_manage_invoice"
    t.boolean "can_read_invoice"
    t.boolean "can_manage_finances_account"
    t.boolean "can_read_finances_account"
    t.datetime "date_registered"
    t.boolean "can_manage_sms"
    t.boolean "can_manage_sms_templates"
    t.boolean "can_read_sms"
    t.boolean "can_read_sms_templates"
    t.boolean "can_manage_tickets"
    t.boolean "can_read_tickets"
    t.string "last_login_ip"
    t.string "last_login_at"
    t.string "current_device"
    t.string "last_activity_at"
    t.jsonb "webauthn_authenticator_attachment"
    t.string "webauthn_id"
    t.boolean "inactive", default: false
    t.datetime "last_activity_active"
    t.boolean "enable_inactivity_check", default: false
    t.boolean "enable_inactivity_check_minutes"
    t.boolean "enable_inactivity_check_hours"
    t.string "can_manage_dashboard"
    t.string "can_read_dashboard"
    t.boolean "can_manage_calendar"
    t.boolean "can_read_calendar"
    t.string "phone_number"
    t.integer "connection_count"
    t.integer "account_id"
    t.integer "conversations_count", default: 0
    t.boolean "online", default: false
    t.datetime "last_seen"
    t.datetime "last_heartbeat"
    t.string "email"
    t.string "fcm_token"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "service_provider_id", null: false
    t.bigint "account_id", null: false
    t.string "status", default: "pending"
    t.datetime "appointment_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "service_provider_id"], name: "index_appointments_on_account_id_and_service_provider_id"
    t.index ["account_id"], name: "index_appointments_on_account_id"
    t.index ["service_provider_id"], name: "index_appointments_on_service_provider_id"
  end

  create_table "calendar_events", force: :cascade do |t|
    t.string "event_title"
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.datetime "start"
    t.datetime "end"
    t.integer "account_id"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.string "content"
    t.datetime "date_time_of_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chat_room_id"
    t.integer "admin_id"
    t.integer "account_id"
    t.integer "customer_id"
    t.integer "customer_sender_id"
    t.bigint "receiver_id"
    t.bigint "conversation_id"
    t.index ["conversation_id"], name: "index_chat_messages_on_conversation_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id", null: false
    t.bigint "admin_id", null: false
    t.index ["admin_id"], name: "index_chat_rooms_on_admin_id"
    t.index ["customer_id", "admin_id"], name: "index_chat_rooms_on_customer_id_and_admin_id", unique: true
    t.index ["customer_id"], name: "index_chat_rooms_on_customer_id"
  end

  create_table "company_settings", force: :cascade do |t|
    t.string "company_name"
    t.string "contact_info"
    t.string "email_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.string "logo"
  end

  create_table "contact_requests", force: :cascade do |t|
    t.string "company_name"
    t.string "business_type"
    t.string "contact_person"
    t.string "business_email"
    t.string "phone_number"
    t.string "expected_users"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "mmessage"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id", null: false
    t.bigint "admin_id", null: false
    t.string "status", default: "active"
    t.integer "messages_count", default: 0
    t.datetime "last_message_at"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_conversations_on_account_id"
    t.index ["admin_id"], name: "index_conversations_on_admin_id"
    t.index ["customer_id", "admin_id"], name: "index_conversations_on_customer_id_and_admin_id", unique: true
    t.index ["customer_id"], name: "index_conversations_on_customer_id"
    t.index ["status"], name: "index_conversations_on_status"
  end

  create_table "credentials", force: :cascade do |t|
    t.string "webauthn_id"
    t.string "public_key"
    t.integer "sign_count"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "system_admin_id"
    t.integer "account_id"
  end

  create_table "customer_payments", force: :cascade do |t|
    t.string "payment_code"
    t.string "phone_number"
    t.string "name"
    t.string "amount_paid"
    t.string "total"
    t.string "remaining_amount"
    t.string "status"
    t.integer "account_id"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_settings", force: :cascade do |t|
    t.boolean "send_sms_and_email"
    t.boolean "send_email"
    t.string "prefix"
    t.string "minimum_digits"
    t.boolean "use_auto_generated_number"
    t.boolean "enable_2fa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.integer "sequence_value"
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
    t.integer "account_id"
    t.integer "total_requests", default: 0
    t.integer "total_confirmations", default: 0
  end

  create_table "email_settings", force: :cascade do |t|
    t.string "smtp_host"
    t.string "smtp_username"
    t.string "sender_email"
    t.string "smtp_password"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.string "domain"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string "customer_confirmation_code_header"
    t.string "customer_confirmation_code_body"
    t.string "customer_confirmation_code_footer"
    t.string "service_provider_confirmation_code_header"
    t.string "service_provider_confirmation_code_body"
    t.string "service_provider_confirmation_code_footer"
    t.string "user_invitation_header"
    t.string "user_invitation_body"
    t.string "user_invitation_footer"
    t.string "customer_otp_confirmation_header"
    t.string "customer_otp_confirmation_body"
    t.string "customer_otp_confirmation_footer"
    t.string "service_provider_otp_confirmation_header"
    t.string "service_provider_otp_confirmation_body"
    t.string "service_provider_otp_confirmation_footer"
    t.string "admin_otp_confirmation_header"
    t.string "admin_otp_confirmation_body"
    t.string "admin_otp_confirmation_footer"
    t.string "store_manager_otp_confirmation_header"
    t.string "store_manager_otp_confirmation_body"
    t.string "store_manager_otp_confirmation_footer"
    t.string "store_manager_number_header"
    t.string "store_manager_number_body"
    t.string "store_manager_number_footer"
    t.string "payment_reminder_header"
    t.string "payment_reminder_body"
    t.string "payment_reminder_footer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.string "password_reset_header"
    t.string "password_reset_body"
    t.string "password_reset_footer"
  end

  create_table "finances_and_accounts", force: :cascade do |t|
    t.string "category"
    t.string "name"
    t.string "description"
    t.datetime "date"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "account_id"
  end

  create_table "my_calendar_settings", force: :cascade do |t|
    t.string "start_in_minutes"
    t.string "start_in_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
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
    t.bigint "subscription_id"
    t.string "payment_method"
    t.integer "amount_cents"
    t.string "currency", default: "KES"
    t.string "status"
    t.string "transaction_reference"
    t.string "mpesa_phone_number"
    t.string "mpesa_receipt_number"
    t.jsonb "payment_details"
    t.integer "account_id"
    t.index ["mpesa_receipt_number"], name: "index_payments_on_mpesa_receipt_number", unique: true
    t.index ["subscription_id"], name: "index_payments_on_subscription_id"
    t.index ["transaction_reference"], name: "index_payments_on_transaction_reference", unique: true
  end

  create_table "prefix_and_digits", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prefix_and_digits_for_service_providers", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prefix_and_digits_for_store_managers", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "send_manager_number_via_sms"
    t.boolean "send_manager_number_via_email"
    t.boolean "enable_2fa_for_store_manager"
  end

  create_table "prefix_and_digits_for_stores", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
  end

  create_table "prefix_and_digits_for_ticket_numbers", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
  end

  create_table "prefixes", force: :cascade do |t|
    t.string "minimum_digits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "s3_uploaders", force: :cascade do |t|
    t.string "region"
    t.string "access_key_id"
    t.string "secret_access_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_provider_locations", force: :cascade do |t|
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "address"
    t.bigint "service_provider_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_service_provider_locations_on_account_id"
    t.index ["service_provider_id"], name: "index_service_provider_locations_on_service_provider_id"
  end

  create_table "service_provider_settings", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.boolean "use_auto_generated_number_for_service_provider"
    t.boolean "send_sms_and_email_for_provider"
    t.boolean "enable_2fa_for_service_provider"
    t.boolean "send_email_for_provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
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
    t.integer "account_id"
    t.decimal "rating", precision: 3, scale: 2, default: "0.0"
    t.decimal "completion_rate", precision: 5, scale: 2, default: "0.0"
    t.integer "total_appointments", default: 0
    t.integer "completed_appointments", default: 0
    t.integer "cancelled_appointments", default: 0
    t.decimal "on_time_delivery_rate", precision: 5, scale: 2, default: "0.0"
    t.boolean "active_status", default: true
    t.datetime "last_active_at"
  end

  create_table "sms", force: :cascade do |t|
    t.string "user"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.string "status"
    t.string "admin_user"
    t.string "system_user"
    t.integer "account_id"
  end

  create_table "sms_settings", force: :cascade do |t|
    t.string "api_key"
    t.string "api_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
  end

  create_table "sms_templates", force: :cascade do |t|
    t.string "customer_confirmation_code_template"
    t.string "service_provider_confirmation_code_template"
    t.string "user_invitation_template"
    t.string "customer_otp_confirmation_template"
    t.string "service_provider_otp_confirmation_template"
    t.string "admin_otp_confirmation_template"
    t.string "payment_reminder_template"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "store_manager_manager_number_confirmation_template"
    t.string "store_manager_otp_confirmation_template"
    t.integer "account_id"
  end

  create_table "store_manager_settings", force: :cascade do |t|
    t.string "prefix"
    t.string "minimum_digits"
    t.boolean "send_manager_number_via_sms"
    t.boolean "send_manager_number_via_email"
    t.boolean "enable_2fa_for_store_manager"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
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
    t.boolean "delivered_bags", default: false
    t.boolean "received_bags", default: false
    t.integer "account_id"
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
    t.integer "account_id"
  end

  create_table "sub_locations", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "created_by"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "status"
    t.datetime "next_billing_date"
    t.integer "amount_cents"
    t.string "currency", default: "KES"
    t.datetime "last_payment_date"
    t.string "payment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "plan_name", default: "Enterprise"
    t.text "features", default: [], array: true
    t.string "renewal_period", default: "monthly"
    t.index ["account_id"], name: "index_subscriptions_on_account_id"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.string "issue_description"
    t.string "status"
    t.string "priority"
    t.string "agent"
    t.string "ticket_number"
    t.string "customer"
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "date_created"
    t.string "ticket_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_of_creation"
    t.serial "sequence_number"
    t.datetime "date_closed"
    t.string "agent_review"
    t.string "agent_response"
    t.integer "account_id"
  end

  create_table "system_admin_credentials", force: :cascade do |t|
    t.string "webauthn_id"
    t.string "public_key"
    t.integer "system_admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sign_count"
  end

  create_table "system_admins", force: :cascade do |t|
    t.string "user_name"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verification_token"
    t.boolean "email_verified", default: false
    t.string "role"
    t.string "fcm_token"
    t.string "webauthn_id"
    t.jsonb "webauthn_authenticator_attachment"
  end

  create_table "theme_settings", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "primary_color", null: false
    t.string "secondary_color", null: false
    t.string "background_color", null: false
    t.string "text_color", null: false
    t.string "sidebar_color", null: false
    t.string "header_color", null: false
    t.string "accent_color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "success"
    t.string "warning"
    t.string "error"
    t.string "sidebar_menu_items_background_color_active", null: false
    t.index ["account_id"], name: "index_theme_settings_on_account_id", unique: true
  end

  create_table "work_sessions", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.date "date", null: false
    t.datetime "last_active_at"
    t.integer "total_time_seconds", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.integer "account_id"
    t.index ["admin_id", "date"], name: "index_work_sessions_on_admin_id_and_date", unique: true
    t.index ["admin_id"], name: "index_work_sessions_on_admin_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "accounts"
  add_foreign_key "appointments", "service_providers"
  add_foreign_key "chat_messages", "conversations"
  add_foreign_key "chat_rooms", "admins"
  add_foreign_key "chat_rooms", "customers"
  add_foreign_key "conversations", "accounts"
  add_foreign_key "conversations", "admins"
  add_foreign_key "conversations", "customers"
  add_foreign_key "payments", "subscriptions"
  add_foreign_key "service_provider_locations", "accounts"
  add_foreign_key "service_provider_locations", "service_providers"
  add_foreign_key "subscriptions", "accounts"
  add_foreign_key "theme_settings", "accounts"
  add_foreign_key "work_sessions", "admins"
end
