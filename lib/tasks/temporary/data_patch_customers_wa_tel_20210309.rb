class DataPatchCustomerWaTel20210304
  def self.execute
    puts "executing DataPatchCustomerWaTel20210304"
    begin
      counter = 0
      customers = Customer.where(wa_tel: [nil, ""]).where.not(tel: [nil, ""])
      customers.each do | customer |
        # triggers 'before_save_wa_tel' method on Customer models
        # sets the wa_tel field for records with a 'tel' value but to a 'wa_tel'
        # and sets the 'send_type' to 'wa'
        customer.save!(validate: false)
        counter += 1
      end
      puts "#{counter} records "
    rescue => e
      puts "ERROR: #{e.message} #{e.backtrace}"
      Rails.logger.error(e.message)
    end
    puts "ending DataPatchCustomerWaTel20210304"
  end
end

DataPatchCustomerWaTel20210304.execute
