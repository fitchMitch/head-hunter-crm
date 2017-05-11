Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'

  get  '/search',     to: 'static_pages#search'
  get  '/help',       to: 'static_pages#help'
  get  '/about',      to: 'static_pages#about'
  get  '/contact',    to: 'static_pages#contact'

  get '/signup',      to: 'users#new'
  post '/signup',     to: 'users#create'


  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get    '/people/:id/addCompany',   to: 'people#add_company'

  get    '/missions/add_ext',   to: 'missions#add_ext'
  get    '/missions/:id/add_ext',   to: 'missions#add_ext'

  get    '/comactions/:id/add_ext',   to: 'comactions#add_ext'
  get    '/comactions/add_ext',   to: 'comactions#add_ext'

  get    '/companies/sort',   to: 'companies#sort_col'

  resources :account_activations,               only: [:edit]
  resources :jobs,                              only: [:new, :create, :edit, :update, :index, :destroy]
  resources :users, :people, :missions, :comactions
  resources :companies do
    member do
      get 'list_people'
    end
  end

  resources :password_resets,                   only: [:new, :create, :edit, :update]

end
