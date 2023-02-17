class Questionnaire < ApplicationRecord
  belongs_to :checkin
  belongs_to :answer_choice_group
  belongs_to :send_message
  has_one :answer
end
