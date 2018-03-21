Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #limit only required routes
    root to: 'accounts#index'
    #resources :accounts, only:[:index] #this is one way to add aoutes
    
    #adding additional custom routes under the resources
    resources :accounts, only:[:index, :new, :create, :destroy]  do
        member do
            get '/atm', to: 'accounts#atm'
            post '/deposit', to: 'accounts#deposit'
            put '/withdraw', to: 'accounts#withdraw'
            put '/clear_suspension', to: 'accounts#clear_suspension'
            #post '/new', to: 'accounts#new'
        end
    end
end
