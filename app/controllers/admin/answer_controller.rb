class Admin::AnswerController < Admin::ApplicationAdminController
  include AnswersHelper

  def index
    @stars = {}
    (1..5).map{|x| @stars[t("admin.answer.star_#{x}")] = x}
    @select_shop = current_user.managed_shops.where(id: session[:default_user_shop]).first
    @select_shop_id = @select_shop.id
    session[:answer_shop_id ] = @select_shop_id
    @answers = policy_scope(Answer).joins({questionnaire: :checkin}).where(checkins: {shop_id: @select_shop_id}).includes(questionnaire: {checkin: :customer})

    @start_date = params[:start_date] || (Date.today).strftime('%Y-%m-%d 00:00:00')
    @end_date = params[:end_date] || (Date.today).strftime('%Y-%m-%d 23:59:59')
    @answers = @answers.where(answered_at: @start_date..@end_date)

    @select_rate ||= params[:rate]
    @answers = @answers.where(rate: params[:rate]) if params[:rate].present?
    @sort_column = sort_column
    @sort_direction = sort_direction
    @answers = @answers.page(params[:page]).per(10).order("#{sort_column} #{sort_direction}")
  end

  def show
    @return = request.referrer

    @answer = policy_scope(Answer).find(params[:id])
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
