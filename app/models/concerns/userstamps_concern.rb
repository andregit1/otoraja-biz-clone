module UserstampsConcern
  extend ActiveSupport::Concern

  included do
    before_create :on_before_create
    before_update :on_before_update
  end

  def on_before_create
    self.created_staff_id = current_staff_id
    self.created_staff_name = current_staff_name
    self.updated_staff_id = current_staff_id
    self.updated_staff_name = current_staff_name
  end

  def on_before_update
    self.updated_staff_id = current_staff_id
    self.updated_staff_name = current_staff_name
  end

private
  def current_staff_id
    ShopStaff.current_staff.try(:id) || '0'
  end

  def current_staff_name
    ShopStaff.current_staff.try(:name) || 'system'
  end
end
