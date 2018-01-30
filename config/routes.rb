# == Route Map
#
#                  Prefix Verb   URI Pattern                             Controller#Action
#            sessions_new GET    /sessions/new(.:format)                 sessions#new
#                    root GET    /                                       comactions#index
#                  search GET    /search(.:format)                       static_pages#search
#                    help GET    /help(.:format)                         static_pages#help
#                   about GET    /about(.:format)                        static_pages#about
#                 contact GET    /contact(.:format)                      static_pages#contact
#                  signup GET    /signup(.:format)                       users#new
#                         POST   /signup(.:format)                       users#create
#                   login GET    /login(.:format)                        sessions#new
#                         POST   /login(.:format)                        sessions#create
#                  logout DELETE /logout(.:format)                       sessions#destroy
#                         GET    /people/:id/addCompany(.:format)        people#add_company
#        missions_add_ext GET    /missions/add_ext(.:format)             missions#add_ext
#                         GET    /missions/:id/add_ext(.:format)         missions#add_ext
#                         GET    /comactions/:id/add_ext(.:format)       comactions#add_ext
#      comactions_add_ext GET    /comactions/add_ext(.:format)           comactions#add_ext
#          companies_sort GET    /companies/sort(.:format)               companies#sort_col
# edit_account_activation GET    /account_activations/:id/edit(.:format) account_activations#edit
#                    jobs GET    /jobs(.:format)                         jobs#index
#                         POST   /jobs(.:format)                         jobs#create
#                 new_job GET    /jobs/new(.:format)                     jobs#new
#                edit_job GET    /jobs/:id/edit(.:format)                jobs#edit
#                     job PATCH  /jobs/:id(.:format)                     jobs#update
#                         PUT    /jobs/:id(.:format)                     jobs#update
#                         DELETE /jobs/:id(.:format)                     jobs#destroy
#                   users GET    /users(.:format)                        users#index
#                         POST   /users(.:format)                        users#create
#                new_user GET    /users/new(.:format)                    users#new
#               edit_user GET    /users/:id/edit(.:format)               users#edit
#                    user GET    /users/:id(.:format)                    users#show
#                         PATCH  /users/:id(.:format)                    users#update
#                         PUT    /users/:id(.:format)                    users#update
#                         DELETE /users/:id(.:format)                    users#destroy
#                  people GET    /people(.:format)                       people#index
#                         POST   /people(.:format)                       people#create
#              new_person GET    /people/new(.:format)                   people#new
#             edit_person GET    /people/:id/edit(.:format)              people#edit
#                  person GET    /people/:id(.:format)                   people#show
#                         PATCH  /people/:id(.:format)                   people#update
#                         PUT    /people/:id(.:format)                   people#update
#                         DELETE /people/:id(.:format)                   people#destroy
#                missions GET    /missions(.:format)                     missions#index
#                         POST   /missions(.:format)                     missions#create
#             new_mission GET    /missions/new(.:format)                 missions#new
#            edit_mission GET    /missions/:id/edit(.:format)            missions#edit
#                 mission GET    /missions/:id(.:format)                 missions#show
#                         PATCH  /missions/:id(.:format)                 missions#update
#                         PUT    /missions/:id(.:format)                 missions#update
#                         DELETE /missions/:id(.:format)                 missions#destroy
#              comactions GET    /comactions(.:format)                   comactions#index
#                         POST   /comactions(.:format)                   comactions#create
#           new_comaction GET    /comactions/new(.:format)               comactions#new
#          edit_comaction GET    /comactions/:id/edit(.:format)          comactions#edit
#               comaction GET    /comactions/:id(.:format)               comactions#show
#                         PATCH  /comactions/:id(.:format)               comactions#update
#                         PUT    /comactions/:id(.:format)               comactions#update
#                         DELETE /comactions/:id(.:format)               comactions#destroy
#     list_people_company GET    /companies/:id/list_people(.:format)    companies#list_people
#               companies GET    /companies(.:format)                    companies#index
#                         POST   /companies(.:format)                    companies#create
#             new_company GET    /companies/new(.:format)                companies#new
#            edit_company GET    /companies/:id/edit(.:format)           companies#edit
#                 company GET    /companies/:id(.:format)                companies#show
#                         PATCH  /companies/:id(.:format)                companies#update
#                         PUT    /companies/:id(.:format)                companies#update
#                         DELETE /companies/:id(.:format)                companies#destroy
#         password_resets POST   /password_resets(.:format)              password_resets#create
#      new_password_reset GET    /password_resets/new(.:format)          password_resets#new
#     edit_password_reset GET    /password_resets/:id/edit(.:format)     password_resets#edit
#          password_reset PATCH  /password_resets/:id(.:format)          password_resets#update
#                         PUT    /password_resets/:id(.:format)          password_resets#update
#

Rails.application.routes.draw do
  get 'sessions/new'

  # root 'static_pages#home'
  root 'comactions#index'

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

  get    '/dahsboard/:id/general',  to: 'dashboard#general'

  get    '/companies/sort',   to: 'companies#sort_col'

  resources :account_activations,               only: [:edit]
  resources :jobs,                              only: [:new, :create, :edit, :update, :index, :destroy]
  resources :dashboards,                         only: [:show]
  resources :users, :people, :missions, :comactions
  resources :companies do
    member do
      get 'list_people'
    end
  end

  resources :password_resets,                   only: [:new, :create, :edit, :update]

end
