# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'orders', :to => 'orders#get'
get 'import', :to => 'orders#import'
match 'order_contracts/:action' => 'order_contracts'
