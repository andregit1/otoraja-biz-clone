class AddProductClassNonSparepart < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.transaction do 
      ProductClass.create!(
        name: 'NON-SPAREPART',
        can_includable: true
      )
    end
  end
end
