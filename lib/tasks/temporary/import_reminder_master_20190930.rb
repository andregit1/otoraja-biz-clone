class ImportReminderMaster20190930
  def self.execute
    ReminderBodyTemplate.create!([
        {title: 'product reminder', template: 'Tiba waktunya untuk ganti [category_name] dan servis silakan anda mampir ke [shop_name]! Terimakasih :) [shop_url]'},
        {title: 'customer reminder', template: 'Bagaimana kondisi motor anda, apakah sudah melakukan perawatan servis rutin di [shop_name]? Terimakasih :) [shop_url]'},
    ])
    ProductCategory.where(product_class: ProductClass.find_by(name: 'PARTS')).update_all(reminder_body_template_id: ReminderBodyTemplate.find_by(title: 'product reminder').id)

    CampaignType.find_by(code_type: :customer_remind).update(reminder_body_template: ReminderBodyTemplate.find_by(title: 'customer reminder'))

    ShopConfig.find_by(shop: Shop.find(156)).update(use_customer_remind: true, customer_remind_interval_days: 45)
    ShopConfig.find_by(shop: Shop.find(223)).update(use_customer_remind: true, customer_remind_interval_days: 30)
    ShopConfig.find_by(shop: Shop.find(240)).update(use_customer_remind: true, customer_remind_interval_days: 30)
    ShopConfig.find_by(shop: Shop.find(244)).update(use_customer_remind: true, customer_remind_interval_days: 60)
  end
end

ImportReminderMaster20190930.execute
