class Front::MakersController < Front::ApiController
  def list
    @makers = Maker.all.order(order: :asc)
  end

  def except_check_token_action
    ['list']
  end
end