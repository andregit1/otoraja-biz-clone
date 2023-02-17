class Admin::StockBookReportsController < Admin::ApplicationAdminController
  def index
    @shop_products = get_stock_products()
    @stock_products = Kaminari.paginate_array(@shop_products).page(params[:page]).per(10)
  end

  def export_stock_book_report
    @shop_products = get_stock_products()
    @stock_products = @shop_products

    respond_to do |format|
      format.csv {
        send_data render_to_string, filename: "stock_book_report_#{Time.zone.now.strftime('%Y%m%d')}_#{Time.parse(params[:start_date]).strftime('%Y%m%d')}-#{Time.parse(params[:end_date]).strftime('%Y%m%d')}.csv"
      }
    end
  end

  private

  def get_stock_products()
    @start_date = params[:start_date] || (Date.today).strftime('%Y-%m-%d')
    @end_date = params[:end_date] || (Date.today).strftime('%Y-%m-%d')
    @q = params[:q] || ""
    @select_category = params[:select_category]
    @last_stock_zero = params[:last_stock_zero] === "1" ? true : false
    @no_stock_movement = params[:no_stock_movement] === "1" ? true : false
    @not_available = params[:not_available] === "1" ? true : false
    @shop_products = ShopProduct.stock_report_scope(session[:default_user_shop], @start_date, @end_date, @q)
    @shop_products = @shop_products.select {|product| product.product_category_id == @select_category.to_i} if @select_category.present?

    if @not_available && @no_stock_movement && @last_stock_zero
      @shop_products
    elsif @not_available && @no_stock_movement
      @shop_products.select {|product| product.last_stock.to_i > 0}
    elsif @not_available && @last_stock_zero
      @shop_products.select {|product| product.stock_in.to_i > 0 || product.stock_out.to_i < 0}
    elsif @no_stock_movement && @last_stock_zero
      @shop_products.select {|product| product.is_use }
    elsif @not_available
      @shop_products.select {|product| product.last_stock.to_i > 0 && (product.stock_in.to_i > 0 || product.stock_out.to_i < 0)}
    elsif @no_stock_movement
      @shop_products.select {|product| product.is_use && product.last_stock.to_i > 0}
    elsif @last_stock_zero
      @shop_products.select {|product| product.is_use && (product.stock_in.to_i > 0 || product.stock_out.to_i < 0)}
    else
      @shop_products.select {|product| product.is_use && product.last_stock.to_i > 0 && (product.stock_in.to_i > 0 || product.stock_out.to_i < 0)}
    end
  end
end
