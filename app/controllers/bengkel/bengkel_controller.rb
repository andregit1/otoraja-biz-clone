class Bengkel::BengkelController < ActionController::Base
  before_action :authenticate_user, if: -> { false }
  before_action :set_response_header
  before_action :off_save_session
  after_action :on_save_session

private
  def set_response_header
    response.headers['Access-Control-Allow-Origin'] = '*'
  end
  def off_save_session
    @ignore_save_session = true
  end
  def on_save_session
    @ignore_save_session = false
  end
end
