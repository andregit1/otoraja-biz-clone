class CreateNotificationTags < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_tags, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name
      t.integer :order
      t.string :text_color
      t.string :body_color
      t.timestamps
    end
    notification_tags = [
      [name: 'Critical', order: 1, text_color: 'FFFFFF', body_color: 'DC3545'],
      [name: 'Warning', order: 2, text_color: '000000', body_color: 'FFC107'],
      [name: 'Infomation', order: 3, text_color: 'FFFFFF', body_color: '007BFF'],
      [name: 'Maintenance', order: 4, text_color: 'FFFFFF', body_color: '343A40'],
      [name: 'ReleaseNote', order: 5, text_color: '000000', body_color: 'F8F9FA'],
    ]
    NotificationTag.create(notification_tags)

    create_table :notification_tag_relations, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :notification, index: false
      t.references :notification_tag, index: false
      t.timestamps
    end
  end
end
