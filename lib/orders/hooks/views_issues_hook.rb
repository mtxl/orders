module Orders
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_show_description_bottom, :partial => "orders/create_contract", :locals => {:issue => @issue}
    end
  end
end
