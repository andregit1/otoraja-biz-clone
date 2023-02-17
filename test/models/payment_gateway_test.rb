require 'test_helper'

class PaymentGatewayTest < ActiveSupport::TestCase
  setup do
    @shop = shops(:one)
    @payment_gateway = PaymentGateway.all
  end

  test 'Get detail shop' do
    search_key = @shop.bengkel_id
    shop_list = Shop.select('bengkel_id, name').where('name LIKE ? or bengkel_id LIKE ? ', "%#{search_key}%", "%#{search_key}%").limit(10).map{ |shop| {:bengkel_id => shop.bengkel_id, :name => shop.name } }
    assert shop_list
  end

  test 'get specific shop bengkel id and name' do
    bengkel_ids = @shop.bengkel_id
    result = {}
    shops = Shop.select('bengkel_id, name').where(bengkel_id: bengkel_ids)
    shops.each do |shop|
      result[shop.bengkel_id] = "#{shop.bengkel_id} : #{shop.name}"
    end
    assert result
  end

  test 'bulk update payment gateway config' do
    payment_gateway_id = PaymentGateway.first.id
    payment_type_id = PaymentType.first.id

    payment_gateway_params = {
      "id"=>{
        "#{payment_gateway_id}"=>{
          "is_active"=>"1",
          "payment_types_attributes"=>{
            "1"=>{
              "id"=>"#{payment_type_id}",
              "is_active"=>"1",
              "shop_list"=>[
                ""
              ],
              "is_use_all"=>"true"
            },
          }
        }
      }
    }
    
    payment_gateways = payment_gateway_params
    errors = {}
    payment_gateways['id'].each do |payment_gateway_id, payment_gateway_attrs|
      payment_gateway = PaymentGateway.find(payment_gateway_id)
      unless payment_gateway.update_attributes(payment_gateway_attrs)
        errors[payment_gateway_id] = payment_gateway.errors
      end
    end
    assert errors.empty?
  end

end
