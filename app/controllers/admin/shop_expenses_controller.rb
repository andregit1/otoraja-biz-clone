class Admin::ShopExpensesController < Admin::ApplicationAdminController

  def index
    @start_date = params[:start_date] || (Date.today).strftime('%Y-%m-%d')
    @end_date = params[:end_date] || (Date.today).strftime('%Y-%m-%d')
    @shop_expense_scope = policy_scope(ShopExpense).
      joins(:supplier).
      where('expense_date' => @start_date..@end_date).where(shop_id: session[:default_user_shop]).
      where('description LIKE ? OR suppliers.name LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    @total_expense = @shop_expense_scope.map{|m| m.value.present? ? m.value : 0 }.inject(:+)
    @shop_expenses = @shop_expense_scope.order(id: :desc).page(params[:page]).per(10)
  end

  def new
    @shop_expense = ShopExpense.new
  end

  def create_supplier
    @supplier = Supplier.new(supplier_params)
    @supplier.shop_id = session[:default_user_shop]
    tel = supplier_params[:tel].present? ? "62" + supplier_params[:tel] : ''
    phone = Phonelib.parse(tel)
    @supplier.tel = phone.international(false)

    if @supplier.save
      respond_to do |format|
        format.js
      end

      # if params[:shop_expense_id].present?
      #   redirect_to edit_admin_shop_expense_path(params[:shop_expense_id], supp_id: @supplier.id)
      # else
      #   redirect_to new_admin_shop_expense_path
      # end
    end
  end

  def create
    # shop_expense_params[:value].gsub(/\./, "")
    @shop_expense = ShopExpense.new(shop_expense_params)
    @shop_expense.shop_id = session[:default_user_shop]

    if @shop_expense.save
      redirect_to admin_shop_expenses_path, notice: 'Laporan pengeluaran berhasil dibuat!'
    else
      render :new
    end
  end

  def edit
    @shop_expense = policy_scope(ShopExpense).find(params[:id])
    @supplier_shop = policy_scope(Supplier).find(params[:supp_id]) if params[:supp_id].present?
  end
  
  def update
    @shop_expense = policy_scope(ShopExpense).find(params[:id])
    # shop_expense_params[:value].gsub(/\./, "")
    @shop_expense.assign_attributes(shop_expense_params)
    
    if @shop_expense.save
      redirect_to admin_shop_expenses_path, notice: 'Laporan pengeluaran berhasil diubah!'
    else
      render :edit
    end
  end

  def destroy
    @shop_expense = ShopExpense.find(params[:id])
    @shop_expense.discard!

    redirect_to admin_shop_expenses_path, notice: 'Laporan pengeluaran berhasil dihapus!'
  end

  def show
    @shop_expense = policy_scope(ShopExpense).find(params[:id])
  end

  def export_expenses_report
    @start_date = params[:start_date] || (Date.today).strftime('%Y-%m-%d')
    @end_date = params[:end_date] || (Date.today).strftime('%Y-%m-%d')
    @shop_expense_scope = policy_scope(ShopExpense).own_shop(policy_scope(Shop)).joins(:supplier).
      where(shop_id: session[:default_user_shop]).where('expense_date' => @start_date..@end_date).
      where('description LIKE ? OR suppliers.name LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    @shop_expenses = @shop_expense_scope.order(id: :desc)

    respond_to do |format|
      format.csv {
        send_data render_to_string, filename: "expenses_report_#{Time.zone.now.strftime('%Y%m%d')}.csv"
      }
    end
  end

  private
    def shop_expense_params
      params.fetch(:shop_expense, {}).permit(
        :value, 
        :no_ref, 
        :description, 
        :supplier_id, 
        :expense_date,
      )
    end

    def supplier_params
      params.permit(:name, :tel, :address)
    end
end
