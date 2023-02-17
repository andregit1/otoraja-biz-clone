class ShopPurchase < ApplicationRecord
  enum modes: { invoice: 0, inventory: 1}
end