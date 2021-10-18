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
		attributes = %w{name stock price active}

		CSV.generate(headers: true) do |csv|
			csv << attributes
			all.each do |sales|
				csv << attributes.map{ |attr| sales.send(attr) }
			end
		end
	end
end
