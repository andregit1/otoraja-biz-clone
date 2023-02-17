class AddBikeColor < ActiveRecord::Migration[5.2]
  def change
    change_column_null :bikes, :maker, true
    change_column_null :bikes, :model, true
    add_column :bikes, :color, :string, :after => 'model', null:true
  end
end
