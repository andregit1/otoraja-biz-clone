class Member::MemberController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user, if: -> { false }
  before_action :set_response_header
  before_action :set_header
  before_action :off_save_session
  after_action :on_save_session

  # 何もシナかったらtrue すり抜けfalse
  def set_header
    get_customer
  end

private
  def set_response_header
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  def get_customer
    begin
      token = request.headers['Authorization']
      sections = token.split('.')
      payload = JSON.load(Base64.decode64(sections[1]))
      cognito_id = payload['cognito:username']
      @customer = Customer.find_by(cognito_id: cognito_id)
      if @customer.nil?
        response_unauthorized
      end
    rescue => e
      logger.fatal(e.backtrace.join('\n'))
      response_internal_server_error
    end
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

  def off_save_session
    @ignore_save_session = true
  end
  def on_save_session
    @ignore_save_session = false
  end
end
