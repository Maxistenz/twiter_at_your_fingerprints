TwitterApp::Application.routes.draw do

  devise_for :users

  root :to => "home#index"

  get 'bio' => 'home#bio'
  get 'tweets' => 'home#tweets'
  get 'home' => 'home#index'
  post 'trend' => 'trend#create'

 end
