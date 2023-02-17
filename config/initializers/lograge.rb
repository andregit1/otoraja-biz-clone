Rails.application.configure do
  if Rails.env.production? || Rails.env.staging? || Rails.env.design?
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.lograge.custom_payload do |controller|
      {
        host: controller.request.host,
        remote_ip: controller.request.remote_ip,
        referer: controller.request.referer,
        user_agent: controller.request.user_agent,
        request_id: controller.request.request_id,
        session_id: controller.request.session_options[:id],
        user_id: controller.current_user.try(:user_id),
        current_user_id: controller.current_user.try(:id),
        available_shops: controller.current_user.try(:shop_ids),
        current_staff_id: controller.session[:current_staff_id],
      }
    end
    config.lograge.ignore_actions = ['HealthCheckController#index']
    config.lograge.custom_options = lambda do |event|
      exceptions = %w(controller action format id)
      data = {
        log_type: 'app_trace_log',
        time: event.time,
        region: event.payload[:region],
        host: event.payload[:host],
        remote_ip: event.payload[:remote_ip],
        referer: event.payload[:referer],
        user_agent: event.payload[:user_agent],
        request_id: event.payload[:request_id],
        session_id: event.payload[:session_id],
        current_user_id: event.payload[:current_user_id],
        user_id: event.payload[:user_id],
        available_shops: event.payload[:available_shops],
        current_staff_id: event.payload[:current_staff_id],
        params: event.payload[:params].except(*exceptions),
        exception_object: nil,
        exception: nil,
        backtrace: nil,
      }
      if event.payload[:exception_object].present?
        data.merge!(
          exception_object: event.payload[:exception_object],
          exception: event.payload[:exception],
          backtrace: event.payload[:exception_object].try(:backtrace)[0..6],
        )
      end
      data
    end
  end
end
