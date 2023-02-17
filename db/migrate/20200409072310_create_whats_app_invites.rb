class CreateWhatsAppInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :whats_app_invites do |t|
      t.references :whats_app_service, index: false
      t.references :customer, index: false
      t.string :hash, index: false
      t.timestamps
    end
  end
end