class ChangeColumnToAnswer < ActiveRecord::Migration[5.2]
  def up
    change_column :answers, :comment, :string, :limit => 500
  end

  def down
    change_column :answers, :comment, :string, :limit => 255
  end
end
