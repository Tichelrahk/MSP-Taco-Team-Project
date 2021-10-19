class Product < ApplicationRecord
	has_many :sale_items

	def self.to_csv 
		CSV.generate do |csv|
			csv << column_names
			all.each do |sales|
				csv << sales.attributes.values_at(*column_names)
			end
		end
	end
end
