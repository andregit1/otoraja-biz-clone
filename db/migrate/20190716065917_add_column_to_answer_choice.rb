class AddColumnToAnswerChoice < ActiveRecord::Migration[5.2]
  def change
    add_column :answer_choices, :export_id, :string, :after => :id, :null => false
  end
end
