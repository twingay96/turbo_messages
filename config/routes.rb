Rails.application.routes.draw do
  root "messages#index"
  get "/messages/index" =>"messages#index" ,as: :turbo_index
  
  '''
  get "/messages" => "messages#index"
  post "/messages" => "messages#create"
  get "/messages/new" => "messages#new"
  get "/messages/:id/edit" => "messages#edit"
  get "/messages/:id" => "messages#show"
  patch "/messages/:id" => "messages#update"
  put "/messages/:id" => "messages#update"
  delete "/messages/:id" => "messages#delete"
  를 한번에
  '''
  resources :messages do #레일즈에서는 routes.rb에 있어 resources 정의를 통해 바로 Restful API로 정의
    member do
      post :edit # edit을 get방식에서 post방식으로 수정
    end
  end

 
  
  # root "articles#index"
end
