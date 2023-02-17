class AnswerChoiceGroup < ApplicationRecord
  has_many :answer_choices
  has_many :questionnaires
end
