class RemoveShopSearchTagIdColumn < ActiveRecord::Migration[5.2]
  def up
    remove_column :shop_search_tags, :search_tag_id
    rename_column :shop_search_tags, :tag_alias, :name
  end

  def down
    add_column :shop_search_tags, :search_tag_id, :bigint, :after => :shop_id
    rename_column :shop_search_tags, :name, :tag_alias
  end
end
