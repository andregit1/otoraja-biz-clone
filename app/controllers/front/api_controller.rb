class Front::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  before_action :set_response_header
  before_action :off_save_session
  before_action :check_token
  after_action :on_save_session

  def check_token
    if !except_check_token_action.include?(action_name) && current_user.nil?
      response_unauthorized
      return
    end
  end

  # 201 Created
  def response_created
    render status: 201, json: { status: 201, message: 'Created' }
  end

  # 204 Created
  def response_no_content
    render status: 204, json: { status: 204, message: 'No Content' }
  end

  # 400 Bad Request
  def response_bad_request
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end

  # 401 Unauthorized
  def response_unauthorized
    render status: 401, json: { status: 401, message: 'Unauthorized' }
  end

  # 500 Internal Server Error
  def response_internal_server_error
    render status: 500, json: { status: 500, message: 'Internal Server Error' }
  end

  def except_check_token_action
    []
  end

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
