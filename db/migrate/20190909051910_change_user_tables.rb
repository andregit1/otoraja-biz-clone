class ChangeUserTables < ActiveRecord::Migration[5.2]
  def up
    # create_table
    create_table :shop_staffs, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.references :shop, index: false
      t.string :name, :limit => 45, null: false
      t.boolean :is_front_staff, null: false
      t.boolean :is_mechanic, null: false
      t.integer :mechanic_grade, null: true
      t.boolean :active, null: false
      t.timestamps
    end

    # maintenance mechanic
    add_reference :maintenance_mechanics, :shop_staff, index: false

    # データ移行
    # users -> shop_staffs
    # メカニック
    User.where(role:'').where.not(mechanic_grade:nil).each do |user|
      shop_staff = ShopStaff.new(
        shop: user.shops.first,
        name: user.name,
        is_front_staff: false,
        is_mechanic: true,
        mechanic_grade: user.mechanic_grade,
        active: true
      )
      shop_staff.save!
    end
    User.where(role:'').where.not(mechanic_grade:nil).delete_all

    # フロントスタッフ
    User.where(role:'staff').where.not('user_id like ?', 'Demo%').where.not('user_id like ?', '%stf').each do |user|
      shop_staff = ShopStaff.new(
        shop: user.shops.first,
        name: user.name,
        is_front_staff: true,
        is_mechanic: !user.mechanic_grade.nil?,
        mechanic_grade: user.mechanic_grade,
        active: true
      )
      shop_staff.save!
    end 
    User.where(role:'staff').where.not('user_id like ?', 'Demo%').where.not('user_id like ?', '%stf').delete_all

    # フロントスタッフ
    AvailableShop.group(:shop_id).count.each do |row|
      if ShopStaff.where(shop_id: row[0]).where(is_front_staff: true).count == 0
        ShopStaff.create(
          shop: Shop.find(row[0]),
          name: 'FrontStaff',
          is_front_staff: true,
          is_mechanic: false,
          mechanic_grade: nil,
          active: true
        )
      end
    end

    # maintenance_mechanics
    MaintenanceMechanic.all.each do |row|
      shop_staff = ShopStaff.find_by(name: row.name)
      unless shop_staff.nil?
        row.shop_staff = shop_staff
        row.save!
      end
    end

    # common_column
    add_column :maintenance_logs, :updated_staff_id, :bigint, null: false, :after => :color
    add_column :maintenance_logs, :updated_staff_name, :string, :limit => 45, null: false, :after => :color
    add_column :maintenance_logs, :created_staff_id, :bigint, null: false, :after => :color
    add_column :maintenance_logs, :created_staff_name, :string, :limit => 45, null: false, :after => :color
    add_column :maintenance_log_details, :updated_staff_id, :bigint, null: false, :after => :note
    add_column :maintenance_log_details, :updated_staff_name, :string, :limit => 45, null: false, :after => :note
    add_column :maintenance_log_details, :created_staff_id, :bigint, null: false, :after => :note
    add_column :maintenance_log_details, :created_staff_name, :string, :limit => 45, null: false, :after => :note
    add_column :checkins, :updated_staff_id, :bigint, null: false, :after => :deleted
    add_column :checkins, :updated_staff_name, :string, :limit => 45, null: false, :after => :deleted
    add_column :checkins, :created_staff_id, :bigint, null: false, :after => :deleted
    add_column :checkins, :created_staff_name, :string, :limit => 45, null: false, :after => :deleted

    Checkin.where.not(created_user_id: 0).each do |checkin|
      shop_staff = ShopStaff.find_by(shop: checkin.shop, is_front_staff: true)
      checkin.update_columns(
        created_staff_id: shop_staff.id,
        created_staff_name: shop_staff.name,
        updated_staff_id: shop_staff.id,
        updated_staff_name: shop_staff.name
      )
    end

    MaintenanceLog.where.not(created_user_id: 0).each do |maintenance_log|
      shop_staff = ShopStaff.find_by(shop: maintenance_log.checkin.shop, is_front_staff: true)
      maintenance_log.update_columns(
        created_staff_id: shop_staff.id,
        created_staff_name: shop_staff.name,
        updated_staff_id: shop_staff.id,
        updated_staff_name: shop_staff.name
      )
    end

    MaintenanceLogDetail.where.not(created_user_id: 0).each do |maintenance_log_detail|
      shop_staff = ShopStaff.find_by(shop: maintenance_log_detail.maintenance_log.checkin.shop, is_front_staff: true)
      maintenance_log_detail.update_columns(
        created_staff_id: shop_staff.id,
        created_staff_name: shop_staff.name,
        updated_staff_id: shop_staff.id,
        updated_staff_name: shop_staff.name
      )
    end

    # change_users
    change_column_null :users, :user_id, true
    change_column_null :users, :role, true
    change_column :users, :role, :string, :limit => 20
    change_column_null :users, :encrypted_password, false
    remove_column :users, :mechanic_grade

    # common_column
    remove_column :maintenance_logs, :updated_user_id
    remove_column :maintenance_logs, :updated_user_name
    remove_column :maintenance_logs, :created_user_id
    remove_column :maintenance_logs, :created_user_name
    remove_column :maintenance_log_details, :updated_user_id
    remove_column :maintenance_log_details, :updated_user_name
    remove_column :maintenance_log_details, :created_user_id
    remove_column :maintenance_log_details, :created_user_name
    remove_column :checkins, :updated_user_id
    remove_column :checkins, :updated_user_name
    remove_column :checkins, :created_user_id
    remove_column :checkins, :created_user_name

    # maintenance mechanic
    remove_reference :maintenance_mechanics, :user, index: true
    remove_column :maintenance_mechanics, :name
  end

  def down
    change_column_null :users, :user_id, false
    change_column_null :users, :role, false
    change_column_null :users, :encrypted_password, true
    add_column :users, :mechanic_grade, :integer, null: true, :after => :role

    remove_column :maintenance_logs, :updated_staff_id
    remove_column :maintenance_logs, :updated_staff_name
    remove_column :maintenance_logs, :created_staff_id
    remove_column :maintenance_logs, :created_staff_name
    remove_column :maintenance_log_details, :updated_staff_id
    remove_column :maintenance_log_details, :updated_staff_name
    remove_column :maintenance_log_details, :created_staff_id
    remove_column :maintenance_log_details, :created_staff_name
    remove_column :checkins, :updated_staff_id
    remove_column :checkins, :updated_staff_name
    remove_column :checkins, :created_staff_id
    remove_column :checkins, :created_staff_name

    add_column :maintenance_logs, :updated_user_id, :bigint, null: false, :after => :color
    add_column :maintenance_logs, :updated_user_name, :string, :limit => 45, null: false, :after => :color
    add_column :maintenance_logs, :created_user_id, :bigint, null: false, :after => :color
    add_column :maintenance_logs, :created_user_name, :string, :limit => 45, null: false, :after => :color
    add_column :maintenance_log_details, :updated_user_id, :bigint, null: false, :after => :note
    add_column :maintenance_log_details, :updated_user_name, :string, :limit => 45, null: false, :after => :note
    add_column :maintenance_log_details, :created_user_id, :bigint, null: false, :after => :note
    add_column :maintenance_log_details, :created_user_name, :string, :limit => 45, null: false, :after => :note
    add_column :checkins, :updated_user_id, :bigint, null: false, :after => :deleted
    add_column :checkins, :updated_user_name, :string, :limit => 45, null: false, :after => :deleted
    add_column :checkins, :created_user_id, :bigint, null: false, :after => :deleted
    add_column :checkins, :created_user_name, :string, :limit => 45, null: false, :after => :deleted

    remove_reference :maintenance_mechanics, :shop_staff, index: false
    add_reference :maintenance_mechanics, :user, index: true
    add_column :maintenance_mechanics, :name, :string

    drop_table :shop_staffs
  end
end
