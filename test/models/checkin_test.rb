require 'test_helper'

class CheckinTest < ActiveSupport::TestCase
  setup do
    @checkin_done = checkins(:done)
    @checkin_processed = checkins(:processed)
    @checkin_deleted = checkins(:deleted)
  end

  test "should get the status done" do
    assert_equal "SELESAI", @checkin_done.get_status
  end

  test "should get the status processed" do
    assert_equal "DIPROSES", @checkin_processed.get_status
  end

  test "should get the status deleted" do
    assert_equal "VOID", @checkin_deleted.get_status
  end
end
