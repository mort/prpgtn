# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140327104038) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "archived_links", force: true do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.integer  "archive_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "channel_invites", force: true do |t|
    t.integer  "channel_id"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "email"
    t.string   "token"
    t.integer  "status",       default: 1, null: false
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "expired_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "channel_settings", force: true do |t|
    t.integer  "channel_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channel_subs", force: true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: true do |t|
    t.integer  "owner_id"
    t.string   "title",                                        null: false
    t.string   "description"
    t.integer  "channel_type",                  default: 1,    null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "max_users"
    t.boolean  "is_deletable",                  default: true, null: false
    t.integer  "post_permissions",              default: 1,    null: false
    t.string   "settings",         limit: 4096
  end

  create_table "emote_sets", force: true do |t|
    t.string   "title"
    t.string   "keyword"
    t.integer  "status",     default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emotes", force: true do |t|
    t.integer  "emote_set_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emotings", force: true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "emote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forwardings", force: true do |t|
    t.integer  "item_id"
    t.integer  "channel_id"
    t.integer  "user_id"
    t.integer  "original_fwd_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.string   "item_token"
    t.text     "body"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "item_type",  default: "url", null: false
    t.integer  "link_id"
    t.boolean  "forwarded",  default: false, null: false
  end

  create_table "link_stats", force: true do |t|
    t.integer  "link_id"
    t.integer  "item_count"
    t.integer  "jump_count"
    t.integer  "kept_count"
    t.integer  "fwd_count"
    t.integer  "twitter_share_count"
    t.integer  "fb_share_count"
    t.integer  "email_share_count"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "links", force: true do |t|
    t.string   "uri"
    t.string   "content_type"
    t.string   "og_title"
    t.string   "og_type"
    t.string   "og_image"
    t.string   "og_url"
    t.text     "og_description"
    t.string   "fetch_method"
    t.boolean  "has_embed"
    t.text     "oembed_response"
    t.datetime "fetched_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "links", ["uri"], name: "index_links_on_uri", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.string   "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.string   "redirect_uri", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "plans", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "max_created_channels"
    t.integer  "max_users_in_channel"
    t.integer  "monthly_price"
    t.string   "monthly_price_currency"
    t.integer  "channels_counter"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                               default: "", null: false
    t.string   "encrypted_password",                  default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "plan_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "display_name"
    t.string   "settings",               limit: 4096
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
