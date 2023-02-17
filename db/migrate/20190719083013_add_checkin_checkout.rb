class AddCheckinCheckout < ActiveRecord::Migration[5.2]
  def up
    add_column :checkins, :checkout_datetime, :datetime, null: true, :after => :datetime
    Checkin.where(checkout_datetime: nil).each do |checkin|
      checkin.checkout_datetime = checkin.datetime
      checkin.save
    end
  end
end
