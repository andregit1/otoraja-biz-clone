class CreateWhatsAppOptins < ActiveRecord::Migration[5.2]
  def change
    create_table :whats_app_optins do |t|
      t.references :customer, index: false
      t.references :whats_app_service, index: false
      t.references :whats_app_invite, index: false
      t.timestamps
    end
  end
end