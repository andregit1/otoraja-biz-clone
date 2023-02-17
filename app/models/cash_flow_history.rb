class CashFlowHistory < ApplicationRecord
  belongs_to :cashable, polymorphic: true

  def total_amount
    self.cashable.cash_flow_histories.map{|m| m.cash_amount }.inject(:+)
  end
end
