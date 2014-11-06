Rails.application.routes.draw do
  match '/properties/:id', to: 'properties#show', via: 'get'
  match '/users', to: 'users#index', via: 'get'
  match '/group/:id/members', to: 'groups#index', via: 'get'
end
