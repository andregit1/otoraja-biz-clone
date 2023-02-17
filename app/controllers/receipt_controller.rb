class ReceiptController < ApplicationController
  before_action :authenticate_user!, except: [:output_for_customer, :output_for_subscriptions_public, :output_cost_estimation_for_customer, :output_down_payment_for_customer]

  include ActiveStorage::Downloading
  include Receipt

  # 店舗出力用
  def output_for_stores
    @checkin = policy_scope(Checkin).find(params[:checkin_id])
    get_receipt
  end

  # カスタマー出力用
  def output_for_customer
    # TokenからCheckinを取得する
    token = Token.find_by(uuid: params[:token], token_purpose: :receipt)
    if token.nil? || token.is_expired
      # 存在しないtokenか期限切れ
      raise ActionController::RoutingError.new('Not Found')
    else
      # tokenをもとにチェックインを取得する
      @checkin = token.checkin
      # レシート発行
      get_receipt
    end
  end

  def output_for_subscriptions_public
    token = Token.find_by(uuid: params[:token], token_purpose: :receipt)
    if token.nil? || token.is_expired
      raise ActionController::RoutingError.new('Not Found')
    else
      @subscription = Subscription.find(token.subscription_id)
      pdf = output_subscription_receipt(@subscription)
      send_data pdf.render,
          filename:    'Invoice.pdf',
          type:        'application/pdf',
          disposition: 'inline'
    end
  end

  def output_for_subscriptions
    @subscription = policy_scope(Subscription).find(params[:subscription_id])
    pdf = output_subscription_receipt(@subscription)

    send_data pdf.render,
        filename:    'Invoice.pdf',
        type:        'application/pdf',
        disposition: 'inline'
  end

  def output_cost_estimation_for_customer
    token = Token.find_by(uuid: params[:token], token_purpose: :receipt)
    @uuid = token.uuid
    if token.nil? || token.is_expired
      raise ActionController::RoutingError.new('Not Found')
    else
      download_blob_to_tempfile do |file|
        filename = file.path
        pdf = Prawn::Document.new(:template => filename)
        send_data pdf.render,
          filename:    "Estimasi Biaya.pdf",
          type:        'application/pdf',
          disposition: 'inline'
      end
    end
  end

  def output_down_payment_for_customer
    token = Token.find_by(uuid: params[:token], token_purpose: :receipt)
    @uuid = token.uuid
    if token.nil? || token.is_expired
      raise ActionController::RoutingError.new('Not Found')
    else
      download_blob_to_tempfile do |file|
        filename = file.path
        pdf = Prawn::Document.new(:template => filename)
        send_data pdf.render,
          filename:    "Uang Muka.pdf",
          type:        'application/pdf',
          disposition: 'inline'
      end
    end
  end

private
  def blob
    if @checkin.present?
     return @checkin.receipt.attachment.blob 
    end
    if @uuid.present?
      return ActiveStorage::Blob.find_by(filename: "MaintenanceLog #{@uuid}.pdf") 
    end
  end

  def get_receipt
    # 日付指定チェックインなどで、メンテナンスログ作成前にチェックアウト処理がされてしまった場合を想定
    unless @checkin.receipt.attached?
      output_receipt(@checkin)
    end
    download_blob_to_tempfile do |file|
      filename = file.path
      pdf = Prawn::Document.new(:template => filename)
      send_data pdf.render,
        filename:    "#{@checkin.receipt.filename}",
        type:        'application/pdf',
        disposition: 'inline'
    end
  end
end
