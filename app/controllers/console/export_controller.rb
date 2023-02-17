
class Console::ExportController < Console::ApplicationConsoleController
  require 'csv'

  def list
  end

  def patterns
    @patterns = ExportPattern.all.includes(export_layouts: :export_type)
  end

  def layout_show
    @export_layout = ExportLayout.find(params[:id])
    @export_layout_columns = @export_layout.export_layout_columns.order(:order).includes([:export_column, :export_masking_rule])
  end

  def layout_edit
    @export_layout = ExportLayout.find(params[:id])
    @export_columns = ExportColumn.where(export_type: @export_layout.export_type)
  end
  
  def layout_update
    @export_layout = ExportLayout.find(params[:id])
    @export_columns = ExportColumn.where(export_type: @export_layout.export_type)

    if @export_layout.update(export_layout_params)
      redirect_to console_export_layout_path(@export_layout), notice: 'Export Layout was successfully updated.'
    else
      render :layout_edit
    end
  end

  def shop_sales_data
    start_date = params[:start_date_sales]
    end_date = params[:end_date_sales]
    range = Range.new(start_date,end_date)
    @sales_data = MaintenanceLogDetail.eager_load(maintenance_log:{checkin: :shop}).where(checkins: {datetime: range} )
    
    respond_to do |format|
      format.csv {
        send_data render_to_string, filename: "sales_data_#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      }
    end
  end

  def item_master
    bucket = "otoraja-biz-report"
    key = "item_master/item_master.csv"
    
    config = Aws::AwsUtility.config
    client = Aws::S3::Client.new(
      region: 'ap-northeast-1',
      access_key_id: config['access_key_id'],
      secret_access_key: config['secret_access_key']
    )

    data = client.get_object(:bucket => bucket, :key => key).body
    file_name = "item_master_#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
    type = 'text/csv'

    send_data data.read, filename: file_name, disposition: 'attachment',  type: type
  end

  def subscriptions_data
    start_date = params[:start_date_subscription]
    end_date = params[:end_date_subscription]
    range = Range.new(start_date,end_date)
    @subscriptions_data = Subscription.eager_load(:shop_group, :shop, :va_code_area).where(start_date: range)

    respond_to do |format|
      format.csv {
        send_data render_to_string, filename: "subscriptions_data_#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      }
    end
  end

  private
    def export_layout_params
      params.fetch(:export_layout, {}).permit(
        :name,
        export_layout_columns_attributes: [
          :id,
          :export_column_id,
          :order,
          :_destroy,
          export_masking_rule_attributes: [
            :id,
            :use_masking,
            :top_no_masking_digits,
            :last_no_masking_digits,
            :_destroy,
          ]
        ]
      )
    end
end
