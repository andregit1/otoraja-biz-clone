class AddColumnToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :reasons, :string,  :after => :review, null:true
  end
end
