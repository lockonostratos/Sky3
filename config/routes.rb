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
        get 'show_product_summary'
      end
    end
    resources :products do
      collection do
        get 'product_of'
      end
    end

    resources :temp_orders
    resources :temp_order_details
    resources :orders
    resources :order_details
    resources :deliveries do
      collection do
        get 'deliveries_of'
      end
    end

    resources :temp_import_details
    resources :warehouses do
      collection do
        get 'available'
      end
    end
  end
end
