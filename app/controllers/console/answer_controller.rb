class Console::AnswerController < Console::ApplicationConsoleController
  
  include AnswersHelper

  def index
    @select_shop_id = params[:answer_shop_id] || session[:answer_shop_id ]
    session[:answer_shop_id ] = @select_shop_id
    @answers = Answer.joins({questionnaire: :checkin}).where(checkins: {shop_id: @select_shop_id}).includes(questionnaire: {checkin: :customer}).page(params[:page]).per(10).order("#{sort_column} #{sort_direction}")
  end

  def show

    @return = request.referrer
  
    @answer = Answer.find(params[:id])
    @shop_id = params[:shop_id]
    @maintenance_log = @answer.questionnaire.checkin.maintenance_log
    @maintenance_log_details = @maintenance_log.maintenance_log_details.includes(maintenance_mechanics: :shop_staff)

    unless @answer.review.nil?
      reviews_export_ids = JSON.parse(@answer.review).map {|h| h['item']}
      @choice_answers = AnswerChoice.where(export_id: reviews_export_ids)
    end
  end

  def export
    @count = Answer.count
    respond_to do |format|
      format.csv {
        send_data Answer.generate_csv, filename: "answers_#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      }
    end
  end
end
