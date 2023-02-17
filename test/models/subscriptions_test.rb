require 'test_helper'

class SubscriptionsTest < ActiveSupport::TestCase
  setup do
    @shop = shops(:one)
    @shop_group = shop_group(:one)
  end

  test "Create new record extension subs" do
    extension_days = 10;
    start_date = Date.today
    end_date = ApplicationController.helpers.convert_to_weekdays(Date.parse(start_date.to_s) + extension_days.days)

    extension_period = Subscription.new(
      shop_group: @shop_group,
      plan: 0,
      fee: 0,
      status: :extension_period,
      shop: @shop,
      start_date: start_date,
      end_date: end_date,
    )
    extension_period.save!

    assert extension_period
  end

  test "Create manual transaction if payment gateway non active" do 
    PaymentGateway.find_by(is_active: true).update!(is_active: false)

    unless @shop.in_list_payment_gateway? 
      subscription = Subscription.new(
        shop_group_id: @shop_group.id,
        plan: 1,
        fee: 125000,
        period: 1,
        shop_id: @shop.id
      )

      subscription.manual_transaction
    end
    assert subscription
  end

  test "Create manual transaction if payment gateway active but not include in shop list" do    
    unless @shop.in_list_payment_gateway? 
      subscription = Subscription.new(
        shop_group_id: @shop_group.id,
        plan: 1,
        fee: 125000,
        period: 1,
        shop_id: @shop.id
      )
      subscription.manual_transaction
    end
    assert subscription, 'Still create subscription with manual transaction'
  end


end
