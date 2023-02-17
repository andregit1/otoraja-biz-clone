require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  setup do
    @service = services(:one)
  end

  test "Should update service" do
    service = @service.update(
      name: 'Ganti Oli',
      created_at: '2021-04-09T21:08:45.000Z',
      updated_at: '2021-04-09T21:08:54.000Z',
    )
    assert service
  end
end