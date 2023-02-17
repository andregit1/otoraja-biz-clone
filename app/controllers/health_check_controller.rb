class HealthCheckController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :off_save_session
  after_action :on_save_session
  skip_before_action :confirm_password_reset

  def index
    render plain:"alive #{Rails.env} #{ENV['AWS_DEFAULT_REGION']}"
  end
private
  def off_save_session
    @ignore_save_session = true
  end
  def on_save_session
    @ignore_save_session = false
  end
end
