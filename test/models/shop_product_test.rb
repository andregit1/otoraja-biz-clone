require 'test_helper'

class ShopProductTest < ActiveSupport::TestCase
  test "Get product without deleted data" do
    product =  ShopProduct.kept
    assert product
  end

  test "Get history transaction product without deleted data " do
    from_datetime = 1.week.ago
    product = ShopProduct.kept
    history_transaction = product.joins({:maintenance_log_details => {:maintenance_log => :checkin}}).where('checkins.datetime > ?', from_datetime)
    assert history_transaction
  end  

  test "Get the latest average price of product" do
    product = shop_product(:one)
    assert_equal 1250, product.last_average_price
  end

  test "Stock report scope includes products within the range" do
    products = ShopProduct.stock_report_scope(1, "2021-11-24", "2021-11-24", "")
    assert_equal 2, products.length
  end

  test "Stock report scope includes products within the keyword" do
    products = ShopProduct.stock_report_scope(1, "2021-11-24", "2021-11-24", "BAN BIASA 2")
    assert_equal "BAN BIASA 2", products.first.shop_alias_name
  end
end
