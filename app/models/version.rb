class Version < ApplicationRecord
  def canChangedAndroidRequiredVersion?
    self.android_require_version != self.android_latest_version
  end
  def canChangedIOSRequiredVersion?
    self.ios_require_version != self.ios_latest_version
  end
end
