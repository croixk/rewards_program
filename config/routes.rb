Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/transactions/add_transaction', to: 'transactions#add_transaction'

      get '/transactions/balances', to: 'transactions#balances'

      post '/transactions/spend_points', to: 'transactions#spend_points'

    end
  end
end
