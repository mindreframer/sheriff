Sheriff::Application.routes.draw do
  match '/', :to => redirect('/alerts')

  resources :alerts do
    collection do
      delete :delete_all
    end
  end
  resources :groups
  resources :reports do
    collection do
      post :batch_validate
      post :clear_alerts
    end
  end
  resources :validations
  resources :deputies do
    collection do
      post :batch
    end
  end
  resources :plugins
  resources :settings do
    collection do
      post :update
      get  :test
      post :reset
    end
  end

  match "/notify", :to => "reports#create"
  match "/resque" => ResqueWeb, :anchor => false if CFG[:resque]
  match '/health', :to => "alerts#health"
end
