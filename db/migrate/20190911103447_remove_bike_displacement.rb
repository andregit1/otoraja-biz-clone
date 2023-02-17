class RemoveBikeDisplacement < ActiveRecord::Migration[5.2]

  def up
    remove_column :bikes, :displacement
    remove_column :bike_models, :displacement
  end

  def down
    add_column :bikes, :displacement, :string, :limit => 45
    add_column :bike_models, :displacement, :string, :limit => 45
  end

end
