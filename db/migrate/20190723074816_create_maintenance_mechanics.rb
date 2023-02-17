class CreateMaintenanceMechanics < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenance_mechanics, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name
      t.references :maintenance_log_detail
      t.references :user
      t.timestamps
    end
  end
end
