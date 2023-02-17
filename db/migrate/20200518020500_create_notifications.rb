class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :subject, :null => false
      t.text :body
      t.integer :status, default: 0
      t.datetime :published_from
      t.datetime :published_to
      
      t.timestamps
    end

    create_table :notification_shops do |t|
      t.references :notification, index: false
      t.references :shop, index: false

      t.timestamps
    end
  end
end
