class PaymentGateway < ApplicationRecord
  has_many :payment_types
  accepts_nested_attributes_for :payment_types

  class << self 
    def search_shop(params)
      search_key = params['search_key']
      shop_list = Shop.select('bengkel_id, name').where('name LIKE ? or bengkel_id LIKE ? ', "%#{search_key}%", "%#{search_key}%").limit(10).map{ |shop| {:bengkel_id => shop.bengkel_id, :name => shop.name } }
    end

    def id_name_shops(bengkel_ids)
      result = {}
      shops = Shop.select('bengkel_id, name').where(bengkel_id: bengkel_ids)
      shops.each do |shop|
        result[shop.bengkel_id] = "#{shop.bengkel_id} : #{shop.name}"
      end
      result
    end

    def bulk_update(payment_gateways)
      errors = {}
      payment_gateways[:id].each do |payment_gateway_id, payment_gateway_attrs|
        payment_gateway = PaymentGateway.find(payment_gateway_id)
        unless payment_gateway.update_attributes(payment_gateway_attrs)
          errors[payment_gateway_id] = payment_gateway.errors
        end
      end
      errors
    end
  end

end