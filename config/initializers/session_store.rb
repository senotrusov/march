
# Be sure to restart your server when you modify this file.

March::Application.config.session_store :cookie_store,
  key: '_march_session',
  expire_after: 4.months

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# March::Application.config.session_store :active_record_store
