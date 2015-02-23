require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json },
    constraints: { subdomain: "api" }, path: '/' do

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:create, :show, :update, :destroy]
      resources :products, only: [:show, :index]
      resources :sessions, only: [:create, :destroy]
    end
  end
  devise_for :users
  root "users#index"
end
