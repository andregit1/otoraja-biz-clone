module Receipt
  extend ActiveSupport::Concern
  included do
    helper_method :output_receipt
    helper_method :output_subscription_receipt
    helper_method :output_receipt_not_paid
  end

  def output_receipt(checkin, receipt_layout = nil)
    shop_config = checkin.shop.shop_config
    # TODO: receiptのlayoutを呼び出し時に指定できるようにする
    pdf = if shop_config.use_receipt
      if shop_config.receipt_layout_A4_portrait?
        ReceiptA4Pdf.new(checkin)
      elsif shop_config.receipt_layout_Cut_portrait?
        ReceiptCutPdf.new(checkin)
      else
        nil
      end
    else
      nil
    end
    
    checkin.receipt.attach(
      io: StringIO.new(pdf.render),
      filename: "#{checkin.checkin_no}.pdf",
      content_type: 'application/pdf'
      ) unless pdf.nil?
  end

  def output_subscription_receipt(subscription)
    pdf = SubscriptionReceiptA4Pdf.new(subscription)
    
  end

  def output_receipt_not_paid(token, reason)
    checkin = token.checkin
    shop_config = checkin.shop.shop_config
    pdf = if shop_config.use_receipt
      if shop_config.receipt_layout_A4_portrait?
        ReceiptA4Pdf.new(checkin, reason)
      elsif shop_config.receipt_layout_Cut_portrait?
        ReceiptCutPdf.new(checkin, reason)
      else
        nil
      end
    else
      nil
    end

    checkin.receipt.attach(
      io: StringIO.new(pdf.render),
      filename: "MaintenanceLog #{token.uuid}.pdf",
      content_type: 'application/pdf'
      ) unless pdf.nil?
  end
end
