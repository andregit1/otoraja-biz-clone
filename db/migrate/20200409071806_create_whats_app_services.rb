class CreateWhatsAppServices < ActiveRecord::Migration[5.2]
  def change
    create_table :whats_app_services do |t|
      t.string :name, limit: 255, index: false
      t.timestamps
    end
  end
end
