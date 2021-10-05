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
		time = Time.now()
	    @sale = Sale.create(saleTime: time)
		item = SaleItem.create(quantity: params[:quantity])
		item.sale = @sale
		item.product = Product.where("params[:name] = products.name")
		item.save
	    if @sale.save
	      redirect_to root_path
	    else
	      render :new
	    end
	end

	def edit
	end

	def update
	end

	def weekly
		week_ago = Time.now() - 7.days
		@sales = Sale.where(saleTime: (week_ago)..Time.now)
		@items = []
		@sales.each do |sale|
			sale.sale_items.each do |item|
				@items << item
			end
		end

		@total_products_sold = {}
		@sales.each do |sale|
			sale.sale_items.each do |item|
				k = item.product
				value = item.quantity.to_i. + (@total_products_sold[k].to_i)
				@total_products_sold[k] = value
			end
		end

		@week_revenue = 0
		@total_products_sold.each do |k, v|
			@week_revenue = @week_revenue + (k.price * v)
		end

	end

	def monthly
		month_ago = Time.now() - 1.month
		@sales = Sale.where(saleTime: (month_ago)..Time.now)

		@total_products_sold = {}
		@sales.each do |sale|
			sale.sale_items.each do |item|
				k = item.product
				value = item.quantity.to_i. + (@total_products_sold[k].to_i)
				@total_products_sold[k] = value
			end
		end

		@month_revenue = 0
		@total_products_sold.each do |k, v|
			@month_revenue = @month_revenue + (k.price * v)
		end
	end

	private

	def set_sale
    	@sales = Sale.find(params[:id])
    end

    # Needs work
    def sale_params
    	params.permit(:saleTime, :name, :quantity)
    end
end
