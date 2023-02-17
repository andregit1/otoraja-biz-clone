class CreateDistrics < ActiveRecord::Migration[5.2]
  def change
    create_table :districs do |t|
      t.belongs_to :regency
      t.string :name
      t.string :code
      t.timestamps null: false
    end
  end
end
