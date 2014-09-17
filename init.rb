require_dependency 'orders/hooks/views_issues_hook'
require_dependency 'orders/pathces/issues_helper_patch'
require_dependency 'orders/wiki_macros/contract_wiki_macros.rb'
#
Redmine::Plugin.register :orders do
  name 'Orders plugin'
  author 'Yuri Beloborodov'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://mirdo.ru'
  author_url 'http://mirdo.ru'
  
  settings :default => {'empty' => true}, :partial => 'settings/orders'
  permission :orders, {:orders => [:get]}, :public => true
  menu :project_menu, :orders, {:controller => 'orders', :action => 'get'}, :caption => :label_orders, :after => :activity,  :param => :project_id
end
