class AddSaveUser < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_logs, :updated_user_id, :bigint, null: false, :after => :reason
    add_column :maintenance_logs, :updated_user_name, :string, :limit => 45, null: false, :after => :reason
    add_column :maintenance_logs, :created_user_id, :bigint, null: false, :after => :reason
    add_column :maintenance_logs, :created_user_name, :string, :limit => 45, null: false, :after => :reason
    add_column :maintenance_log_details, :updated_user_id, :bigint, null: false, :after => :note
    add_column :maintenance_log_details, :updated_user_name, :string, :limit => 45, null: false, :after => :note
    add_column :maintenance_log_details, :created_user_id, :bigint, null: false, :after => :note
    add_column :maintenance_log_details, :created_user_name, :string, :limit => 45, null: false, :after => :note
    add_column :checkins, :updated_user_id, :bigint, null: false, :after => :datetime
    add_column :checkins, :updated_user_name, :string, :limit => 45, null: false, :after => :datetime
    add_column :checkins, :created_user_id, :bigint, null: false, :after => :datetime
    add_column :checkins, :created_user_name, :string, :limit => 45, null: false, :after => :datetime
  end
end
