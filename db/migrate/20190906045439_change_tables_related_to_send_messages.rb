class ChangeTablesRelatedToSendMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :send_messages, :message_id, :string, :after => :send_purpose

    remove_column :questionnaires, :url_sent_at, :datetime

    add_reference :questionnaires, :send_message, index: false, :after => :accessed_at
    add_reference :questionnaires, :answer_choice_group, index: false, :after => :accessed_at
    add_reference :answer_choices, :answer_choice_group, index: false, :after => :positive

    answer_choice_group = AnswerChoiceGroup.create(name: 'Default')
    SendMessage.all.each do |send_message|
      questionnaire = Questionnaire.find_or_initialize_by(checkin: send_message.checkin)
      questionnaire.send_message = send_message
      questionnaire.answer_choice_group = answer_choice_group
      questionnaire.save
    end

    AnswerChoice.all.each do |answer_choice|
      answer_choice.update(answer_choice_group: answer_choice_group)
    end

    remove_reference :send_messages, :checkin
  end
end
