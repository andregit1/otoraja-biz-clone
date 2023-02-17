require "csv"

class InterviewImport
  def self.execute
    unless ARGV.length == 1
      puts "ex:#{File.basename(__FILE__)} import_data.csv"
      return
    end

    # AWS Setting
    s3 = Aws::AwsUtility.S3_client
    begin
      obj = s3.get_object({
        bucket: 'otoraja-biz-datastore',
        key: "Interview_import/#{ARGV[0]}"
      })
    rescue => exception
      puts "#{exception} file:#{ARGV[0]}"
      return
    end

    menus = {
      'Engine Oil Change': MaintenanceMenu.find_by(name: 'Ganti Oli Mesin'),
      'Gear Oil Change': MaintenanceMenu.find_by(name: 'Ganti Oli Gear'),
      'Tire Change (Front)': MaintenanceMenu.find_by(name: 'Ganti Kampas Rem Depan'),
      'Tire Change (Rear)': MaintenanceMenu.find_by(name: 'Ganti Kampas Rem Belakang'),
      'Brake Pad Change (Front)': MaintenanceMenu.find_by(name: 'Ganti Ban Depan'),
      'Brake Pad Change (Rear)': MaintenanceMenu.find_by(name: 'Ganti Ban Belakang'),
      'Regural Check': MaintenanceMenu.find_by(name: 'Service Ringan'),
      'Others': MaintenanceMenu.find_by(name: 'Lainnya')
    }
    reasons = {
      'Nothing': 'Tidak lihat apa2',
      'Paper advertisement': 'Tidak lihat apa2',
      'SMS/WA Massage': 'dari Bengkel ada berita Wa/SMS',
    }
    CSV.parse(obj.body.read, headers: true, skip_blanks: true) do |row|
      if row['Hour'].blank?
        next
      end
      if row['AM/PM'] == 'PM' && row['Hour'] == '12'
        hour = 12
      else
        hour = row['AM/PM'] == 'PM' ? row['Hour'].to_i + 12 : row['Hour'].to_i
      end

      date = "#{row['YEAR']}-#{row['MONTH']}-#{row['Day']}T#{hour}:#{row['Minutes']}:00+7:00"
      datetime = DateTime.parse(date).in_time_zone('UTC')
      phoneobj = Phonelib.parse("+62#{row['Phone Number']}")
      phone = phoneobj.valid? ? phoneobj.international(false) : nil

      shop = Shop.find_by(bengkel_id: row['Bengkel ID'])

      customer = Customer.find_by(tel: phone)
      if phone.nil? || customer.nil?
        customer = Customer.create(
          tel: phone,
          name: row['Name']
        )
      end

      checkin = Checkin.create(
        datetime: datetime,
        checkout_datetime: datetime,
        customer: customer,
        shop: shop,
        deleted: false,
      )

      maker = row['Brand'] == 'Others' ? row['Other Brand Name'].upcase : row['Brand']
      maker = maker.blank? ? 'Other' : maker
      displacement = row['cc']
      if is_num(displacement)
        cc = displacement.to_i
        if 1 <= cc && cc <= 50
          displacement = '1cc - 50cc'
        elsif 51 <= cc && cc <= 125
          displacement = '51cc - 125cc'
        elsif 126 <= cc && cc <= 250
          displacement = '126cc - 250cc'
        elsif 251 <= cc && cc <= 500
          displacement = '251cc - 500cc'
        elsif 501 <= cc && cc <= 1000
          displacement = '501cc - 1000cc'
        elsif 1001 <= cc && cc <= 1500
          displacement = '1001cc - 1500cc'
        elsif 1501 <= cc && cc <= 2000
          displacement = '1501cc - 2000cc'
        else
          displacement = '2001cc - 9999cc'
        end
      end
      num_plate_number = is_num(row['Number']) ? row['Number'] : nil
      num_plate_number = row['Number'] == '0000' ? '0000' : num_plate_number
      exp_mon = row['Expiration Month'] || nil
      exp_year = row['Expiration Year'] || nil
      mile = row['Mileage'].blank? ? 0 : unformatNumber(row['Mileage'])
      mile = is_num(mile) ? mile : 0
      reason = row['What brought you here?'].blank? ? 'Tidak lihat apa2' : reasons[row['What brought you here?'].to_sym]
      maintenance_log = MaintenanceLog.create(
        name: row['Name'],
        checkin: checkin,
        maker: maker,
        model: row['Model'],
        displacement: displacement,
        number_plate_area: row['Area'],
        number_plate_number: num_plate_number,
        number_plate_pref: row['Pref'],
        expiration_month: exp_mon,
        expiration_year: exp_year,
        mileage: mile,
        reason: reason,
      )

      if maintenance_log.id.nil?
        puts "maintenance log error"
        puts row.to_json
        puts maintenance_log.errors.inspect
        next
      end

      owned_bike = OwnedBike.find_by(
        customer: customer,
        number_plate_area: row['Area'],
        number_plate_number: num_plate_number,
        number_plate_pref: row['Pref'],
        )
      if owned_bike.nil? && row['Area'].present? && num_plate_number.present? && row['Pref'].present?
        bike = nil
        if maker.present? && row['Model'].present? && displacement.present?
          bike = Bike.create(
            maker: maker,
            model: row['Model'],
            displacement: displacement,
          )
        end
        OwnedBike.create(
          customer: customer,
          bike: bike,
          number_plate_area: row['Area'],
          number_plate_number: num_plate_number,
          number_plate_pref: row['Pref'],
          expiration_month: exp_mon,
          expiration_year: exp_year,
        )
      end

      menus.each do |k, v|
        if k == 'Others'
          unless row["#{k} Total price"] == 0
            log_detail = MaintenanceLogDetail.create(
              maintenance_log: maintenance_log,
              maintenance_menu: v,
              unit_price: unformatNumber(row["#{k} Total price"]),
            )
            if log_detail.id.nil?
              puts "maintenance log detail error"
              puts row.to_json
              puts log_detail.errors.inspect
              next
            end
          end
        else
          if row["#{k} Name"].present?
            log_detail = MaintenanceLogDetail.create(
              maintenance_log: maintenance_log,
              maintenance_menu: v,
              name: row["#{k} Name"],
              quantity: row["#{k} Quantity"],
              unit_price: unformatNumber(row["#{k} Unit Price"]),
            )
            if log_detail.id.nil?
              puts "maintenance log detail error"
              puts row.to_json
              puts log_detail.errors.inspect
              next
            end
          end
        end
      end
    end
  end

private
  def self.unformatNumber(val)
    return val.gsub(/(\d{0,3}),(\d{3})/, '\1\2')
  end

  def self.is_num(val)
    return val.to_i.to_s == val.to_s
  end

end

InterviewImport.execute
