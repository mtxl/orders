require_dependency 'issue'

module IssuePatch
  def self.included(base)
    base.class_eval do
      unloadable
      serialize :order_info
    end
  end
end

Issue.send(:include, IssuePatch)
