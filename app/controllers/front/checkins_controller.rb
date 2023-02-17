class Front::CheckinsController < Front::ApiController
  def list
    mode = params[:mode].to_sym
    if mode == :deleted
      @checkins = policy_scope(Checkin)
    else
      date_from = Otoraja::DateUtils.parse_date_tz(params[:date_from]) if params[:date_from].present?
      date_to = Otoraja::DateUtils.parse_end_date_tz(params[:date_to]) if params[:date_to].present?
      if params[:date_from].present? && params[:date_to].present?
          base_date = (params[:base_date] || 'datetime').to_sym
          @checkins = policy_scope(Checkin).where(base_date => date_from..date_to)
      else
        @checkins = policy_scope(Checkin)
      end
    end

    @checkins = set_checkin_list_condition(mode, @checkins)

    unless mode == :deleted
      @checkins = @checkins.order(params[:order])
    else
      @checkins = @checkins.order(datetime: :desc)
    end

    @checkins = @checkins.page(params[:page] || 1).per(params[:per_page] || 10)
  end

  def search_list
    customers = Customer.es_search(params[:search_word], current_user.shops.ids).per(100).records
    @checkins = policy_scope(Checkin).where(customer_id: customers.ids)
    @checkins = set_checkin_list_condition(params[:mode].to_sym, @checkins)
    @checkins = @checkins.order(datetime: :desc)
    @checkins = @checkins.page(params[:page] || 1).per(params[:per_page] || 10)
    render 'list'
  end

private

  def set_checkin_list_condition(mode, checkins)
    if mode == :all
      checkins = checkins.where(deleted: false)
    elsif mode == :uncheckdout
      checkins = checkins.where(is_checkout: false).where(deleted: false)
    elsif mode == :checkdout
      checkins = checkins.where(is_checkout: true).where(deleted: false)
    elsif mode == :deleted
      checkins = checkins.where(deleted: true)
    end
    checkins
  end
end
