require 'csv'

class Answer < ApplicationRecord
  belongs_to :questionnaire

  serialize :reasons, Array

  scope :own_shop, ->(shop_ids) {
    joins({questionnaire: :checkin}).where(checkins: { shop_id: shop_ids } ).group(:id)
  }

  def self.generate_csv(records = nil)
    # CSVヘッダ生成
    csv_attributes = ['bengkel_id', 'tel', 'answer_date']
    export_ids = ['S1']
    positive_count = AnswerChoice.where(positive: true).length + 1  # 設問数にコメント用IDの分+1する
    negative_count = AnswerChoice.where(positive: false).length + 1
    positive_ids = ["S2_#{positive_count}"]
    negative_ids = ["S3_#{negative_count}"]
    positive_ids.concat(AnswerChoice.where(positive: true).map{|choice| choice.export_id})
    negative_ids.concat(AnswerChoice.where(positive: false).map{|choice| choice.export_id})
    positive_ids.sort_by! {|id| id.sub(/S2_/, '').to_i}
    negative_ids.sort_by! {|id| id.sub(/S3_/, '').to_i}
    export_ids.concat(positive_ids)
    export_ids.concat(negative_ids)
    csv_attributes.concat(export_ids)
    csv_attributes.push("visiting_reasons")
    records = all if records.nil?

    # CSV生成
    CSV.generate(headers: true, force_quotes: true) do |csv|
      csv << csv_attributes
      records.each do |answer|
        checkin = answer.questionnaire.checkin
        csv_values = []

        # bengkel_id
        csv_values.push(checkin.shop.bengkel_id)

        # tel
        csv_values.push(checkin.customer.tel)

        # answer_date
        answer_date = answer.answered_at.in_time_zone('Jakarta').strftime('%Y/%m/%d %H:%M')
        csv_values.push(answer_date)

        # S1
        csv_values.push(answer.rate)

        # S2
        if answer.rate < 5
          csv_values.concat(Array.new(positive_count))
        else
          positive_ids.each_with_index do |id, index|
            if index + 1 === positive_count
              csv_values.push(answer.comment.empty? ? nil : answer.comment)
            else
              csv_values.push(answer.has_review?(id) ? 1 : 0)
            end
          end
        end

        # S3
        if answer.rate === 5
          csv_values.concat(Array.new(negative_count))
        else
          negative_ids.each_with_index do |id, index|
            if index + 1 === negative_count
              csv_values.push(answer.comment.empty? ? nil : answer.comment)
            else
              csv_values.push(answer.has_review?(id) ? 1 : 0)
            end
          end
        end
        # 来店理由
        csv_values.push("\"#{answer.reasons.join(',')}\"")
        csv << csv_values
      end
    end
  end

  def has_review?(export_id)
    has_review = false
    if self.review
      reviews = JSON.parse(self.review)
      reviews.each do |item|
        if item.has_value?(export_id)
          has_review = true
        end
      end
    end
    has_review
  end
end
