class CheckinController < ApplicationController
  include Checkout

  before_action :set_front_staff
  # before_action :staff_list
  before_action :get_checkin_day

  def index
    # DB上はUTCで管理しているため、変換する
    tz_today = DateTime.parse("#{@today.year}-#{@today.month}-#{@today.day} 00:00:00 +0700")
    tz_checkin_day = DateTime.parse("#{@checkin_day.year}-#{@checkin_day.month}-#{@checkin_day.day} 00:00:00 +0700")
    checkin_from = tz_checkin_day.in_time_zone('UTC')
    checkin_to = (tz_checkin_day.to_time + (60 * 60 * 24 - 1)).in_time_zone('UTC')
    @all_checkins = policy_scope(Checkin).where(datetime: checkin_from..checkin_to).order(datetime: :desc)
    @uncheckout_checkins = policy_scope(Checkin).where(datetime: checkin_from..checkin_to).where(checkout_datetime: nil).where(deleted: false).order(datetime: :desc)

    # 当日のチェックイン数(削除含まず)
    @today_checkin = policy_scope(Checkin).where(datetime: checkin_from..checkin_to).where(deleted: false).count
    # 当日のチェックアウト数(削除含まず)
    @today_ckeckout = policy_scope(Checkin).where.not(checkout_datetime: nil).where(datetime: checkin_from..checkin_to).where(deleted: false).count
    # 昨日以前の未チェックアウト数(削除含まず)
    @before_not_ckeckout = policy_scope(Checkin).where('datetime < ?', tz_today).where(checkout_datetime: nil).where(deleted: false).count
  end

  def uncheckout_list
    tz_today = DateTime.parse("#{@today.year}-#{@today.month}-#{@today.day} 00:00:00 +0700")
    # DB上はUTCで管理しているため、変換する
    checkin_from = tz_today.in_time_zone('UTC')
    checkin_to = (tz_today.to_time + (60 * 60 * 24 - 1)).in_time_zone('UTC')
    @checkins = policy_scope(Checkin).where('datetime < ?', checkin_from).where(checkout_datetime: nil).where(deleted: false).order(datetime: :asc).page(params[:page]).per(8)
  end

  def delete_checkin
    update_checkin_deleted(true)
    redirect_to_front
  end

  def undelete_checkin
    update_checkin_deleted(false)
    redirect_to_front
  end

  def checkout
    do_checkout(policy_scope(Checkin).find(params[:id]), params[:send_sms], PaymentMethod.find(params[:payment_method_id]))
    redirect_to_front
  end

  private
    def set_front_staff
      unless session[:current_staff_id].present?
        shop_staffs = policy_scope(ShopStaff).active_front_staffs
        session[:current_staff_id] = shop_staffs.first.id if shop_staffs.count == 1
      end
    end

    # def staff_list
    #   @staff_list = policy_scope(ShopStaff).active_front_staffs
    # end

    def get_checkin_day
      # WIB(ジャカルタ時間)取得
      now = DateTime.now.in_time_zone('Jakarta')
      @today = Date.new(now.year, now.month, now.day)
      if params[:checkin_day].present?
        @checkin_day = Date.parse(params[:checkin_day])
      else
        @checkin_day = @today
      end
    end

    def update_checkin_deleted(flg)
      checkin = policy_scope(Checkin).find(params[:id])
      checkin.deleted = flg
      checkin.save
    end

    def redirect_to_front
      if /uncheckout_list/ =~ request.referer
        redirect_to front_uncheckout_list_path
      else
        if params[:checkin_day].present?
          redirect_to front_setday_path(params[:checkin_day])
        else
          redirect_to front_index_path
        end
      end
    end

end
