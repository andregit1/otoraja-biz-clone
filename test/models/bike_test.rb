require 'test_helper'

class BikeTest < ActiveSupport::TestCase
  test "should create bike with odometer" do
    bike = Bike.create!(maker: "TRIUMPH", model: "BONNEVILLE", color: "Putih", odometer: 10000)

    assert_equal 10000, bike.odometer
  end
end
