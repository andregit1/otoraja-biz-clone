require 'test_helper'

class FacilityTest < ActiveSupport::TestCase
  setup do
    @facility = facilities(:one)
  end

  test "Should update facility" do
    facility = @facility.update(
      name: 'Cemilan',
      created_at: '2021-04-09T21:08:45.000Z',
      updated_at: '2021-04-09T21:08:54.000Z',
    )
    assert facility
  end
end