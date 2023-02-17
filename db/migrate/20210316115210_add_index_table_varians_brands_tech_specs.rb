class AddIndexTableVariansBrandsTechSpecs < ActiveRecord::Migration[5.2]
  def change
    add_index :variants, :name
    add_index :brands, :name
    add_index :tech_specs, :name
  end
end
