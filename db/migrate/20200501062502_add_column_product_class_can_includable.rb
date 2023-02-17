class AddColumnProductClassCanIncludable < ActiveRecord::Migration[5.2]
  def change
    add_column :product_classes, :can_includable, :boolean, :after => 'name'
    if ProductClass.all.count > 0
      ProductClass.find_by(name: 'PARTS').update(can_includable: true)
      ProductClass.find_by(name: 'SERVICE').update(can_includable: true)
      ProductClass.create(name: 'PACKAGE', can_includable: false)
    end
  end
end
