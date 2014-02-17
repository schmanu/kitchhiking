Kitchhiking::Application.routes.draw do
  get "dinners/new"
  get "dinners/show"
  get "home/index"
  post "dinners/create"
  patch "dinners/create"
  root to: "home#index"
  get "requests/new/:dinnerid", to: "requests#new"
  post "requests/create"
  post "requests/update_state"
  devise_for :hikers, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }, controllers: { registrations: 'hikers/registrations'}
  get '/img/:name', to: redirect {|params, req| "/assets/#{params[:name]}.#{params[:format]}" }
  patch "hikers/edit"
  post "hikers/edit"
end
