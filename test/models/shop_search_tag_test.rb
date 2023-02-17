require 'test_helper'

class ShopSearchTagTest < ActiveSupport::TestCase
  setup do
    @search_tag = shop_search_tags(:one)
  end

  test "Should update search tag" do
    shop = Shop.find_by(bengkel_id: '100001')
    search_tag = @search_tag.update(
      shop_id: shop.id,
      name: 'Ban',
      order: true,
      is_using: 1,
      created_at: '2021-04-09T21:08:00.000Z',
      updated_at: '2021-04-09T21:08:00.000Z'
    )
    assert search_tag
  end
end
