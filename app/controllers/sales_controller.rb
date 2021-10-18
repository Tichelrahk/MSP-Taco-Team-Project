class SalesController < ApplicationController
	def index
		@sales = Sale.all
		@products = Product.all
		respond_to do |format|
			format.html
			format.csv { render text: @sale.to_csv }
	end
end

	def import 
		sales.import(params[:file])	
		redirect_to sales_path, notice: "uploaded successfully" 
	end

	def about
	end

	def new
	end

	#Needs Work
	def create	
		productID1 = params[:product_id1].to_i
		itemQuantity1 = params[:quantity1].to_i
		item1 = SaleItem.create(quantity: itemQuantity1)
		productID2 = params[:product_id2].to_i
		itemQuantity2 = params[:quantity2].to_i
		item2 = SaleItem.create(quantity: itemQuantity2)
		if Product.exists?(:id => productID1)			
			sale = Sale.create(saleTime: Time.now())
			item1.sale = sale
			item1.product = Product.find(productID1)
			item1.save
			if Product.exists?(:id => productID2)
				item2.sale = sale
				item2.product = Product.find(productID2)
				item2.save
			end
			if sale.save
			  redirect_to root_path
			else
			  render :new
			end	
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

	def destroy
		@sale = Sale.find(params[:id])
		@sale.delete

		redirect_to root_path
    end

	def prediction
		#to keep flash message after redirect_to display flash message
		flash.keep
		#when search is done
		if params[:search]
			#entered id by user
			@search_term = params[:search]
			#sales from now to last month
			@saleitemsm1 = SaleItem.where(product_id: @search_term, created_at: (Time.now-1.month)..Time.now)
			#sales between 1 month ago to 2 months ago
			@saleitemsm2 = SaleItem.where(product_id: @search_term, created_at: (Time.now-2.month)..Time.now-1.month)
			
			#final predicted value initialised
			@predicted_value = 0
			if(SaleItem.where(product_id: @search_term).present?)

				# check if sale data 1 exists
				if @saleitemsm1.present?
					@saleitemsm1.each do |s|
						@predicted_value += s.quantity
					end
				end
				#check if sale data 2 exists
				if @saleitemsm2.present?
					@saleitemsm2.each do |s|
						@predicted_value += s.quantity
					end
					@predicted_value /=2
				end
				
				if(@predicted_value == 0)
					display = "There is not enough data to predict sales of this item."
				else
				display = "The next months prediction for the item with id #{@search_term} is #{@predicted_value} units."
				end
			else
				display = "There is no item in the database with that id."
			end
			redirect_to displayprediction_path, :flash => { :notice => display}
			
		end
	end

	private

	def set_sale
    	@sales = Sale.find(params[:id])
    end

	def sale_items_params
		params.permit(:product_id, :quantity)
	end

    def sale_params
    	params.require(:sale).permit(:saleTime)
    end
end
