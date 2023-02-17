require 'test_helper'

class SupplierTest < ActiveSupport::TestCase
  test "Should create supplier with the same name on different shop" do
    supplier_one = Supplier.create(shop_id: 1, name: "Apple")
    supplier_two = Supplier.new(shop_id: 2, name: "Apple")
    assert supplier_two.save
  end

  test "Should not create supplier with the same value on every attribute" do
    supplier_one = Supplier.create(shop_id: 1, name: "Apple")
    supplier_two = Supplier.new(shop_id: 1, name: "Apple")
    assert_not supplier_two.save
  end

  test "Should not permanent delete" do
    supplier = Supplier.create(shop_id: 1, name: "Apple")
    supplier.discard

    assert supplier.discarded?

    supplier.undiscard

    assert supplier.present?
  end
end
