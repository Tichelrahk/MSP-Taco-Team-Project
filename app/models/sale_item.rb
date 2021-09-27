class SaleItem < ApplicationRecord
  belongs_to :sale
  belongs_to :product

  def total_cents
    product.price * quantity
  end
end
