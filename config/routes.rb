# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'orders', :to => 'orders#get'
post 'import', :to => 'orders#import'
get 'attachments/bulk_download/:issues_ids', :to => 'attachments#bulk_download'
