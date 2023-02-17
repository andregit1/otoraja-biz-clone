module ActiveRecord
  module SessionStore
    class CustomSession < Session
      def save
        if @ignore_save_session
          return
        end
        super
      end
    end
  end
end
