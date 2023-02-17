class CreateSearchTags < ActiveRecord::Migration[5.2]
  def change
    create_table :search_tags, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :tag, limit: 255, index: false 
      t.timestamps
    end

    create_table :shop_search_tags, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.references :search_tag, index: false
      t.string :tag_alias, limit: 255, index: false
      t.integer :order, index: false
      t.boolean :is_using, index: false
      t.timestamps
    end
  end
end
