Rails.application.routes.draw do
  root "messages#index"
  #post "messages/:id/cancel" => "messages#cancel" ,as: :cancel_message
  resources :messages do
    member do
      post 'cancel'
    end
  end

  resources :messages do 
    member do
      post :edit # edit post(format.turbo_stream 에대한  ajax요청)요청추가 
    end
  end
  # root "articles#index"
end
