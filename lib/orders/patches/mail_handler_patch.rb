module Orders
  module MailHandlerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable

        alias_method_chain :receive, :order
      end
    end
  
    module InstanceMethods
      def receive_with_order(email)
        sender_email = email.from.to_a.first.to_s.strip
        if active_user_email(sender_email)
          receive_without_order(email)
        else
          issues = find_open_issues(sender_email)
          case issues.count
          when 0
            receive_unresolved(sender_email, email)
          when 1
            receive_resolved(issues, email)
          else
            receive_resolved_many(sender_email, email)
          end
        end
      end

      private

      def setup_receive(email)
        @email = email
        @user = User.anonymous
        User.current = user
      end

      def setup_handler_options(options)
        handler_options = self.class.class_variable_get(:@@handler_options)
        handler_options[:issue].merge!(options) 
        self.class.class_variable_set(:@@handler_options, handler_options)
      end

      def active_user_email(email)
        EmailAddress.joins(:user).where(address: email).where('users.status = 1').first
      end

      def receive_unresolved(sender_email, email)
        options ={ Setting[:plugin_orders][:order_email] => sender_email }
        setup_handler_options(options)
        receive_without_order(email)
      end

      def receive_resolved(issues, email)
        setup_receive(email)
        issue = issues.first
        receive_issue_reply(issue.id.to_i)
      end

      def receive_resolved_many(sender_email, email)
        options ={ Setting[:plugin_orders][:order_email] => sender_email,
                   :tracker => Setting[:plugin_orders][:unresolved_tracker]}
        setup_handler_options(options)
        receive_without_order(email)
      end

      def find_open_issues(sender_email)
        issues = Issue.open.joins(:custom_values).
          where("issues.id = custom_values.customized_id").
          where("custom_values.value = '#{sender_email}'").all
      end
    end
  end
end

MailHandler.send(:include, Orders::MailHandlerPatch)
