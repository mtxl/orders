module Orders
  module Hooks
    class ViewContextMenusHooks < Redmine::Hook::ViewListener
      render_on :view_issues_context_menu_end, :partial => "context_menus/attachments_download" 
    end
  end
end
