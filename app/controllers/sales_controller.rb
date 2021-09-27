class SalesController < ApplicationController
	def index
		@sales = Sale.all
		@products = Product.all
	end

	def about
	end

	def new
	end

	def create
	end

	def edit
	end
end
