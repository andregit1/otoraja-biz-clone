require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  setup do
    @shop = shops(:one)
    @available_shops = available_shops(:one)
    @shop_group = shop_group(:one)
  end

  test 'Create new shop branch' do
    period = 1
    current_user = User.first
    facility_id = Facility.first.id
    service_id = Service.first.id
    start_date = DateTime.now.beginning_of_day
    expiration_date = Shop.subscription_end_period(start_date, period)

    shop_params = {
      "shop_group_id"=>@shop_group.id,
      "name"=>"otoraja-1",
      "tel"=>"082219094081",
      "tel2"=>"082219094081",
      "tel3"=>"082219094081",
      "region_id"=>"5",
      "province_id"=>"29",
      "regency_id"=>"436",
      "address"=>"jln. Anoa 1 ",
      "shop_business_hours_attributes"=>{
        "0"=>{
          "is_holiday"=>"false",
          "day_of_week"=>"mon",
          "open_time_hour"=>"01",
          "open_time_minute"=>"00",
          "close_time_hour"=>"01",
          "close_time_minute"=>"00"
        },
        "1"=>{
          "is_holiday"=>"true",
          "day_of_week"=>"tue",
          "open_time_hour"=>"01",
          "open_time_minute"=>"00",
          "close_time_hour"=>"01",
          "close_time_minute"=>"00"
        },
        "2"=>{
          "is_holiday"=>"true",
          "day_of_week"=>"wed",
          "open_time_hour"=>"01",
          "open_time_minute"=>"00",
          "close_time_hour"=>"01",
          "close_time_minute"=>"00"
        },
        "3"=>{
          "is_holiday"=>"true",
          "day_of_week"=>"thu",
          "open_time_hour"=>"01",
          "open_time_minute"=>"00",
          "close_time_hour"=>"01",
          "close_time_minute"=>"00"
        },
        "4"=>{
          "is_holiday"=>"true",
          "day_of_week"=>"fri",
          "open_time_hour"=>"01",
          "open_time_minute"=>"00",
          "close_time_hour"=>"01",
          "close_time_minute"=>"00"
        },
        "5"=>{
          "is_holiday"=>"true",
          "day_of_week"=>"sat",
          "open_time_hour"=>"01",
          "open_time_minute"=>"00",
          "close_time_hour"=>"01",
          "close_time_minute"=>"00"
        },
        "6"=>{
          "is_holiday"=>"true",
          "day_of_week"=>"sun",
          "open_time_hour"=>"01",
          "open_time_minute"=>"00",
          "close_time_hour"=>"01",
          "close_time_minute"=>"00"
        }
      },
      "facility_ids"=>[
        "",
        facility_id
      ],
      "service_ids"=>[
        "",
        service_id
      ],
      "shop_search_tags_attributes"=>{
        "0"=>{
          "name"=>"OLI",
          "order"=>"1"
        },
        "1"=>{
          "name"=>"REM",
          "order"=>"2"
        },
        "2"=>{
          "name"=>"AKI",
          "order"=>"3"
        },
        "3"=>{
          "name"=>"BAN",
          "order"=>"4"
        },
        "4"=>{
          "name"=>"BELT",
          "order"=>"5"
        },
        "5"=>{
          "name"=>"JASA",
          "order"=>"6"
        },
        "6"=>{
          "name"=>"HONDA",
          "order"=>"7"
        },
        "7"=>{
          "name"=>"YAMAHA",
          "order"=>"8"
        },
        "8"=>{
          "name"=>"SUZUKI",
          "order"=>"9"
        },
        "9"=>{
          "name"=>"VESPA",
          "order"=>"10"
        },
        "10"=>{
          "name"=>"BUSI",
          "order"=>"11"
        },
        "11"=>{
          "name"=>"KABEL",
          "order"=>"12"
        },
        "12"=>{
          "name"=>"TROMOL",
          "order"=>"13"
        },
        "13"=>{
          "name"=>"LAMPU",
          "order"=>"14"
        },
        "14"=>{
          "name"=>"RANTAI",
          "order"=>"15"
        },
        "15"=>{
          "name"=>"GIGI",
          "order"=>"16"
        },
        "16"=>{
          "name"=>"FILTER",
          "order"=>"17"
        },
        "17"=>{
          "name"=>"CLEANER",
          "order"=>"18"
        },
        "18"=>{
          "name"=>"SAKLAR",
          "order"=>"19"
        },
        "19"=>{
          "name"=>"PER",
          "order"=>"20"
        }
      }
    }

    shop = Shop.new(shop_params)
    shop.expiration_date = (DateTime.now + period.max_day)
    shop.initial_setup = false
    shop.subscriber!
    shop.save!

    subscription = Subscription.new(
      shop_group: @shop_group,
      plan: 0,
      fee: 0,
      period: 1,
      status: :demo_period,
      shop: shop,
      start_date: start_date,
      end_date: expiration_date,
      payment_date: Date.today
    )
    
    subscription.save!
    shop.update!(active_plan: subscription.id)

    AvailableShop.create(shop: shop, user: current_user)

    assert shop
  end

  test "Should update bengkel" do
    shop = @shop.update(
      bengkel_id: '100001',
      shop_group_id: 6,
      name: "Test",
      tel: "082219094088",
      tel2: "082219094088",
      tel3: "082219094088",
      address: "Jl. Kasuari Blok HB2 No.31, Pd. Aren, Kota Tangerang Selatan, Banten 15229",
      longitude: 106.71,
      latitude: -6.27867,
      region_id: 2,
      province_id: 12,
      regency_id: 168,
      created_at: '2021-04-09T21:08:45.000Z',
      updated_at: '2021-04-09T21:08:54.000Z',
      active_plan: nil,
      expiration_date: '2021-05-09T21:08:45.000Z',
      subscriber_type: 1,
      virtual_bank_no: "",
    )
    assert shop
  end
  
  test "Initial setup shop check" do 
    owner_setup_incomplite = @shop.initial_setup.blank? && @owner      
    if owner_setup_incomplite
      has_initial_shop = @shop.valid?(:update_shop)
      has_initial_staff = @shop.shop_staffs.present?
      has_initial_user = @shop.has_staff_account? | @shop.has_manager_account? | @shop.has_shop_manager_account?
      owner_setup_complite = has_initial_shop && has_initial_staff && has_initial_user
    end

    assert_not owner_setup_complite
  end

  test "Should check if shop is returning customer" do
    assert @shop.returning_customer?
  end
end