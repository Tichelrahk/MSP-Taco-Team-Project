class ProductsController < ApplicationController
	def index
		@products = Product.all
	end

	def create
	end

	def new
	end

	def edit
	end
end
