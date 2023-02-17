class AddCheckinDeleted < ActiveRecord::Migration[5.2]
  def change
    add_column :checkins, :deleted, :boolean, null: false, :after => :datetime
  end
end
