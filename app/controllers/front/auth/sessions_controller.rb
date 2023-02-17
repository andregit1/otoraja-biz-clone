class Front::Auth::SessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:new, :create]

  def provider
    'user_id'
  end

  def create
    # Check
    field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

    @resource = nil
    if field
      q_value = get_case_insensitive_field_from_resource_params(field)

      @resource = find_resource(field, q_value)
    end

    # フロント使用可能なロールのみ許可する
    # @see devise_token_auth-1.1.3/app/controllers/devise_token_auth/sessions_controller.rb#create
    # ↓Original logic
    # if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
    # ↓Modified logic
    if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?) && @resource.is_available_front?
      valid_password = @resource.valid_password?(resource_params[:password])
      if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
        return render_create_error_bad_credentials
      end
      @token = @resource.create_token
      @resource.save

      sign_in(:user, @resource, store: false, bypass: false)

      yield @resource if block_given?

      render_create_success
    elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      if @resource.respond_to?(:locked_at) && @resource.locked_at
        render_create_error_account_locked
      elsif (!@resource.active_for_authentication?)
        render_create_error_account_suspend
      else
        render_create_error_not_confirmed
      end
    else
      render_create_error_bad_credentials
    end
  end

  def render_create_success
    # render json: {
    #   status: "success",
    #   data: resource_data(
    #     resource_json: ActiveModel::SerializableResource.new(@resource).as_json
    #   )
    # }
    # @resource will have been set by set_user_by_token concern
    if @resource
      render json: {
        status: :success,
        success: true,
        data: @resource.as_json,
        shops: @resource.managed_shops_front_apps.as_json
      }
    else
      render json: {
        success: false,
        errors: ["Ada masalah dengan user anda dan password, silahkan ulangi kembali."]
      }, status: 401
    end
  end

  def render_create_error_account_suspend
    render json: {
      success: false,
      subscriber_status: false,
      errors: ["Tidak memiliki bengkel aktif, silahkan check ke smc"]
    }, status: 401
  end
end
