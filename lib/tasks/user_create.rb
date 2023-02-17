require 'json'

class UserCreate
  def self.execute
    unless ARGV.length == 1
      puts "ex:#{File.basename(__FILE__)} import_data.json"
      return
    end

    # AWS Setting
    s3 = Aws::AwsUtility.S3_client
    begin
      obj = s3.get_object({
        bucket: 'otoraja-biz-datastore',
        key: "User_create/#{ARGV[0]}"
      })
    rescue => exception
      puts "#{exception} file:#{ARGV[0]}"
      return
    end

    data = JSON.parse(obj.body.read)
    accounts = data['accounts']
    accounts.each do |row|
      row['uid'] = row['user_id'] unless row['uid'].present?
      row['password_updated_at'] = DateTime.now
      user = User.create!(row.except('available_shops'))
      row['available_shops'].each do |shop|
        AvailableShop.create(user: user, shop: Shop.find_by(bengkel_id: shop))
      end
    end
    staffs = data['staffs']
    staffs.each do |shop|
      bengkel = Shop.find_by(bengkel_id: shop['shop'])
      shop['list'].each do |row|
        shop_staff = ShopStaff.new(row)
        shop_staff.shop = bengkel
        shop_staff.save!
      end
    end
  end
end

UserCreate.execute
