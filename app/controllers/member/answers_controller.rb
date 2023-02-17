class Member::AnswersController < Member::MemberController
  def create
    token = Token.find_by(uuid: params[:uuid])
    checkin = Checkin.find(token.checkin_id)
    questionnaire = Questionnaire.find_by(checkin: checkin)
    answer = Answer.find_or_initialize_by(questionnaire: questionnaire)
    answer.submitted_at = DateTime.now

    if save_answer(answer)
      token.expired_at = DateTime.now
      token.save
    end
  end

  def list
    # アンケートを開いた日時を保存
    checkin = Checkin.find_by(id: params[:checkin_id], customer: @customer, deleted: false)
    questionnaire = Questionnaire.find_or_initialize_by(checkin: checkin)
    questionnaire.accessed_at = DateTime.now
    questionnaire.save

    @positive_choice = AnswerChoice.where(answer_choice_group: questionnaire.answer_choice_group).where(positive: true).order("RAND()")
    @negative_choice = AnswerChoice.where(answer_choice_group: questionnaire.answer_choice_group).where(positive: false).order("RAND()")
    @visiting_reasons = VisitingReason.by_checkin_id(checkin.id)
  end

  private
    def save_answer(answer)
      permited_params = params.require(:answer).permit(:rate, :comment, review: [], reasons: [])

      # json文字列に変換してreviewに保持
      reviews = permited_params.has_key?('review') ? permited_params[:review] : []
      reasons = permited_params.has_key?('reasons') ? permited_params[:reasons] : []
      array = []
      reviews.each do |id|
        array.push({'item': id})
      end

      reasonsArray = []
      reasons.each do |reason|
        reasonsArray.push(reason)
      end

      answer.review = array.empty? ? nil : array.to_json
      answer.reasons = reasonsArray
      answer.answered_at = DateTime.now
      answer.rate = permited_params[:rate]
      answer.comment = permited_params[:comment]

      answer.save
    end
end
