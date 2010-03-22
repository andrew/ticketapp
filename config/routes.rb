ActionController::Routing::Routes.draw do |map|
  
  map.resources :users, :member => {:replies => :get, :delete => :get} do |user|
    user.resources :tickets
  end
  
  map.resources :feedbacks
  map.resources :tickets, :collection => {:newest => :get}

  #map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.resources :sessions#, :collection => { :begin => :post, :complete => :get }
  map.forgot_password '/forgot_password', :controller => 'index', :action => 'forgot_password'
  map.reset_password '/reset_password/:id', :controller => 'index', :action => 'reset_password'
  # map.delete_user '/users/:id/delete', :controller => 'users', :action => 'delete'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.users_rss_feed '/:id.rss', :controller => 'users', :action => 'show', :format => 'rss'
  map.users_atom_feed '/:id.atom', :controller => 'users', :action => 'show', :format => 'atom'
  map.index '/', :controller => 'index', :action => 'index'
  map.login_name '/:id', :controller => 'users', :action => 'show'
  
end
