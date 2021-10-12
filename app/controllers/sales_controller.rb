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
	    @sale = Sale.new(sale_params)
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

	def monthlyprediction
		month_ago = Time.now() - 1.month
		forminputs = [:searchid]
		forminputs.each do |f|
		@form_complete = true
		if params.has_key? f and not params[f].blank?
			@form_complete = true
		else
			@form_complete = false
		end
	end
	@saleitems = SaleItem.where(created_at: (month_ago)..Time.now, product_id: params[:searchid])
	@form_complete = true
	@saleq = " "
	if @form_complete
		#@saleq = @saleitems[0].quantity
			form_status_msg = "This products predicted sale is:"+@saleq+ "units"
		end
		respond_to do |format|
			format.html do
			  flash.now[:status_msg] = form_status_msg
			  render :monthlyprediction, locals: { feedback: params }
			end
		  end
		  #<p>This products predicted sale is: <%= @saleq %> units</p>
    

		@sales = Sale.where(saleTime: (month_ago)..Time.now)

		# 
		# @predictedvalue = {}
		# @sales= Sale.where(name: "aspirin")
		# @sales.each do |sale|
		# 	sale.sale_items.each do |item|
		# 		k = item.product
		# 		value = item.quantity.to_i. + (@predictedvalue[k].to_i)
		# 		@predictedvalue[k] = value
		# 	end
		# end

		# @value = 0
		# @predictedvalue.each do|k, v|
		# 	@value = @value +(k.price*v)
		# end


	end
	private

	def set_sale
    	@sale = Sale.find(params[:id])
    end

    # Needs work
    def sale_params
    	params.require(:sale).permit(:name, :description, :photo)
    end
end
