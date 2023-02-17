class AddLatestVersionColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :android_latest_version, :string, :after => 'android_require_version'
    add_column :versions, :ios_latest_version, :string, :after => 'ios_require_version'
    Version.all.first.update(android_latest_version: '1.0.0')
  end
end
