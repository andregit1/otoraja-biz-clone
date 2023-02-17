class CreateWhatsAppTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :whats_app_templates do |t|
      t.references :whats_app_service, index: false
      t.integer :environment, index: false
      t.string :template_name, limit: 255, null: false
      t.timestamps
    end
  end
end
