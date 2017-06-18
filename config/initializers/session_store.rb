# Be sure to restart your server when you modify this file.

  Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 60.minutes
 #Rails.application.config.session_store :cookie_store, key: '_bst_session'
