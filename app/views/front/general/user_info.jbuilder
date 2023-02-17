json.set! :user do
  json.extract! @user, :id, :name, :user_id, :role, :password_updated_at, :active_for_authentication?
end
