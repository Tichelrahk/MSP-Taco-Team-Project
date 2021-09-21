class SalesController < ApplicationController
	def index
		@sales = Sale.all
		@products = Product.all
		@items = SaleItem.all
	end
end
