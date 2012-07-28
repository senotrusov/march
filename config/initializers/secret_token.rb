# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

file = Rails.root+'config'+'cookie.key'

March::Application.config.secret_token =
  File.exists?(file) && (key = File.read(file).strip) && key.present? && key ||
  Digest::SHA2.hexdigest("#{Time.now.to_f}#{rand}")
