class AddColumnToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :submitted_at, :datetime, :after => :answered_at
  end
end
