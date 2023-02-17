class DeletePaymentTypeQrisShopee < ActiveRecord::Migration[5.2]
  def change
    qris_shopee = PaymentType.find_by(name: 'qris_shopee')
    qris_shopee.delete
  end
end
