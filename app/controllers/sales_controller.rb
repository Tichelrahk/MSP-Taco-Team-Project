class SalesController < ApplicationController
	def index
		@sales = Sale.all
		@products = Product.all
	end
end
