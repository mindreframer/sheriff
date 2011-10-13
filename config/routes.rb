Sheriff::Application.routes.draw do
  match '/', :to => redirect('/alerts')

  resources :alerts do
    collection do
      delete :delete_all
    end
  end
  resources :groups
  resources :summaries
  resources :reports do
    collection do
      post :batch_validate
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
    end
  end

  match "/notify", :to => "reports#create"
  match "/resque" => ResqueWeb, :anchor => false if CFG[:resque]
end
