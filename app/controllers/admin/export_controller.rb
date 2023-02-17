
class Admin::ExportController < Admin::ApplicationAdminController
  
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
      redirect_to admin_export_layout_path(@export_layout), notice: 'Export Layout was successfully updated.'
    else
      render :layout_edit
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
