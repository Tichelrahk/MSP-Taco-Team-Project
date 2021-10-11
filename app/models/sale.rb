class Sale < ApplicationRecord
	has_many :sale_items
	has_many :products, through: :sale_items

	#CSV.foreach(file.path, headers: true) do |row|
	#	sales.create! row.to_hash 
	#end

	def total_price
  		sale_items.sum { |item| (item.product.price * item.quantity) }
	end

	def money_format(cents)
		sprintf('%.2f', (cents/100).to_f)
	end

	def self.to_csv 
		CSV.generate do |csv|
			csv << column_names
			all.each do |sale|
				csv << sale.attributes.values_at(*column_names)
			end
		end
	end
end
