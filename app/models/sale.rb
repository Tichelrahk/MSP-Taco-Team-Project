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
		attributes = %w{name stock price active created_at updated_at}

		CSV.generate(headers: true) do |csv|
			csv << attributes
			all.each do |products|
				csv << attributes.map{ |attr| products.send(attr) }
			end
		end
	end

	def self.to_csv1 
		attributes = %w{id saleTime dollars sale_items}

		CSV.generate(headers: true) do |csv|
			csv << attributes
			all.each do |sale|
				data = []
				array = []
				data << sale.id
				data << sale.saleTime
				total = 0
				sale.sale_items.each do |si|
					array << "product name = #{si.product.name}, quantity = #{si.quantity}, price = #{si.product.price/100}"
					total += (si.product.price * si.quantity)
				end
				data << total/100
				data << array
				csv << data
			end
		end
	end
end
