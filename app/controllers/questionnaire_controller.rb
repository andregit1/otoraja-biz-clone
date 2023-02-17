class QuestionnaireController < ApplicationController
  layout 'questionnaire'
  before_action :authenticate_user!, if: :use_before_action?
  before_action :verify_token
  skip_before_action :verify_authenticity_token, only:[:save]

  def index
    checkin = Checkin.find(@token.checkin_id)

    # アンケートを開いた日時を保存
    @questionnaire = Questionnaire.find_or_initialize_by(checkin: checkin)
    @questionnaire.accessed_at = DateTime.now
    @questionnaire.save
    
    @shop_name = checkin.shop.name
    @answer = Answer.new
    @positive_choice = AnswerChoice.where(answer_choice_group: @questionnaire.answer_choice_group).where(positive: true).order('RAND()')
    @negative_choice = AnswerChoice.where(answer_choice_group: @questionnaire.answer_choice_group).where(positive: false).order('RAND()')
  end

  # submit時にアンケートの回答を保存
  def create
    checkin = Checkin.find(@token.checkin_id)
    questionnaire = Questionnaire.find_by(checkin: checkin)
    answer = Answer.find_or_initialize_by(questionnaire: questionnaire)
    answer.submitted_at = DateTime.now

    if save_answer(answer)
      @token.expired_at = DateTime.now
      @token.save
    else
      render :index
    end
  end

  # ajaxで保存用
  def save
    questionnaire_id = params.require(:questionnaire).permit(:id)[:id]
    answer = Answer.find_or_initialize_by(questionnaire_id: questionnaire_id)
    save_answer(answer)
    render :json => {}
  end

  private
    def verify_token
      @uuid = params[:uuid]
      @token = Token.find_by(uuid: @uuid, token_purpose: :questionnaire)
      if @token
        if @token.expired_at < DateTime.now
          not_found
        end
      else
        not_found
      end
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    def use_before_action?
      false
    end

    def save_answer(answer)
      permited_params = params.require(:answer).permit(:rate, :comment, :reasons, review: [] )

      # json文字列に変換してreviewに保持
      reviews = permited_params.has_key?('review') ? permited_params[:review] : []
      reasons = permited_params.has_key?('reasons') ? permited_params[:reasons] : []
      array = []
      reviews.each do |id|
        array.push({'item': id})
      end

      answer.review = array.empty? ? nil : array.to_json
      answer.reasons = [permited_params[:reasons]]
      answer.answered_at = DateTime.now
      answer.rate = permited_params[:rate]
      answer.comment = permited_params[:comment]

      answer.save
    end
end
