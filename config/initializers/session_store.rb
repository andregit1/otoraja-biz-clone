ActionDispatch::Session::ActiveRecordStore.session_class = ActiveRecord::SessionStore::CustomSession
Rails.application.config.session_store :active_record_store, :key => '_app_session', :expire_after => 24.hour, secure: (Rails.env.production? || Rails.env.staging? || Rails.env.design?)
