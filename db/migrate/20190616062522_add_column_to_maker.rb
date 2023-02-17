class AddColumnToMaker < ActiveRecord::Migration[5.2]
  def change
    add_column :makers, :order, :int, :default => 0, :after => :name
  end
end
