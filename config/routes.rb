Rails.application.routes.draw do
  root :to => 'home#index', as: 'home'
  get 'signin', :to => 'sessions#new', as: 'signin'
  get 'signout', :to => 'sessions#destroy', as: 'signout'
  get 'signup', :to => 'accounts#new', as: 'signup'
  resources :sessions

  scope "api" do
    resources :sessions do
      collection do
        get 'current_user'
        get 'current_merchant_user'
      end
    end
    resources :accounts

    resources :merchant_accounts do
      collection do
        get 'sellers'
      end
    end

    resources :customers

    resources :product_summaries do
      collection do
        get 'import_availables'
      end
    end

    resources :temp_orders
    resources :temp_order_details

    resources :temp_import_details
  end
end
