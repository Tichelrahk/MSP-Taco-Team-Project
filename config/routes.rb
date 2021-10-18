Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'sales#index'
  get "about", to: "sales#about"
  get "weekly-reports", to: "sales#weekly"
  get "monthly-reports", to: "sales#monthly"
  resources :sales, only: %i[new create edit update] do 
    collection { post :import} 
  end
  resources :products, only: %i[index new create edit update] 
end
