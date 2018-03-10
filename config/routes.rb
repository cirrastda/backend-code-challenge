Rails.application.routes.draw do
  	get 'cost', to: 'costs#process'

	post 'distance', to: 'distances#add'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
