class Console::VersionsController < Console::ApplicationConsoleController
  before_action :get_record

  def index
  end

  def require_to_latest
    if params[:type] == 'android'
      @version.update(android_require_version: @version.android_latest_version)
    elsif params[:type] == 'ios'
      @version.update(ios_require_version: @version.ios_latest_version)
    end
    # TODO Mypage Application Version type ... mypage_android,mypage_ios
    redirect_to console_versions_path
  end

private
  def get_record
    @version = Version.all.first
  end
end
