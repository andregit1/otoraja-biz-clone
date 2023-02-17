class CreateVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :versions, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :android_require_version
      t.string :ios_require_version
      t.timestamps
    end
    Version.create(android_require_version: '1.0.0')
  end
end
