Rails.application.routes.draw do
  get 'okta/callback'
  get '/authorization-code/callback', to: 'okta_auth#callback'
  get '/okta/exchange_token', to: 'okta_auth#exchange_token'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
