module AnswersHelper
  def sort_asc(column_to_be_sorted, shop_id)
    link_to '▲', {:answer_shop_id => shop_id, :column => column_to_be_sorted, :direction => 'asc'}
  end

  def sort_desc(column_to_be_sorted, shop_id)
    link_to '▼', {:answer_shop_id => shop_id, :column => column_to_be_sorted, :direction => 'desc'}
  end

  def sort_direction
    %W[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    params[:column].nil? ? 'answered_at' : params[:column]
  end
end
