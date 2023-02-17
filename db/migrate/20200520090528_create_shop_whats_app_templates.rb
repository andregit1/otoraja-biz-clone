class CreateShopWhatsAppTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_whats_app_templates do |t|
      t.references :shop, index: false
      t.references :whats_app_service, index: false
      t.references :whats_app_template, index: false
      t.timestamps
    end
  end
end
