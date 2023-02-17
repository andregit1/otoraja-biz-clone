require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  setup do
    @customer = customer(:one)
  end

  test "Should update customer tel and wa_tel" do
    customer = @customer.update(
      tel: '6282121217927',
      wa_tel: '6282121217927',
    )
    assert customer
  end  
  
  test "Should update wa_tel" do
    update_customer = @customer.update(
      tel: '6282121217927',
      wa_tel: nil
    )
    assert customer

    assert_equal "6282121217927", @customer.wa_tel
  end  
end
