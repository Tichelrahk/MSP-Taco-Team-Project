class Sale < ApplicationRecord
	has_many :sale_items
	has_many :products, through: :sale_items

	def total_price
  		sale_items.sum { |item| (item.product.price * item.quantity) }
	end

	def money_format(cents)
		sprintf('%.2f', (cents/100).to_f)
	end
end
