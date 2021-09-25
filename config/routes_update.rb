Rails.application.routes.draw do
	get "/sales", to: "sales#index"
	get "/index", to: "sales#index"
	get "/about", to: "sales#about"
	get "/index.html.erb", to: "sales#index"
	get "/about.html.erb", to: "sales#about"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'sales#index'
end
