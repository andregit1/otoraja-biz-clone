class AddCodeToProvincesAndRegencies < ActiveRecord::Migration[5.2]
  def change
    add_column :regencies, :code, :string
    add_column :provinces, :code, :string
  end
end
