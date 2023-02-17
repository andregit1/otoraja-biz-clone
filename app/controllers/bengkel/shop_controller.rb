class Bengkel::ShopController < Bengkel::BengkelController
  def get
    @shop = Shop.find_by(bengkel_id: params[:bengkel_id])
  end

  def list
    availables = AvailableShop.all.pluck(:shop_id)
    shops = Shop.where(province_id: params[:province_id])

    if availables.blank?
      @shops = shops
    else
      @shops = shops.where(id: availables) + shops.where.not(id: availables)
    end
  end

  def province_list
    @provinces = Shop.group(:province).count.inject([]){|array, (model, count)| array << model }
  end
end
