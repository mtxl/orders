require File.expand_path('../../test_helper', __FILE__)

class MailHandlerDecoratorTest < ActiveSupport::TestCase
  #fixtures :users
  FIXTURES_PATH = Rails.root.to_s + '/test/fixtures/mail_handler'

  def setup
    ActionMailer::Base.deliveries.clear
    Setting.notified_events = Redmine::Notifiable.all.collect(&:name)
  end

  def teardown
    Setting.clear_cache
  end

  def test_receive_unresolved
    field = IssueCustomField.create!(:name => 'order_email', :field_format => 'string', :is_for_all => true, :tracker_ids => [1,2,3])
    email_sender = "john.doe@somenet.foo"
    with_settings :plugin_orders => {:order_email => field.name} do 
      assert_no_difference 'User.count' do
        assert_difference 'Issue.count' do
          issue = submit_email(
                    'ticket_by_unknown_user.eml',
                    :issue => {:project => 'onlinestore'},
                    :no_permission_check => '1',
                    :unknown_user => 'accept'
                  )
          assert issue.author.anonymous?
          assert_equal issue.custom_field_value(field.id), email_sender
        end
      end
    end
  end

  def test_receive_from_active_user
    assert_no_difference 'User.count' do
      assert_difference 'Issue.count' do
        assert_difference 'Attachment.count' do
          issue = submit_email(
              'ticket_with_attachment.eml',
              :issue => {:project => 'onlinestore'},
              :no_permission_check => '1',
              :unknown_user => 'accept'
          )
          assert issue.is_a?(Issue)
          assert_equal issue.author, User.find(2)
        end
      end
    end
  end

  def test_receive_resolved
    field = IssueCustomField.create!(:name => 'order_email', :field_format => 'string', :is_for_all => true, :tracker_ids => [1,2,3])
    issue = Issue.first
    author = issue.author
    issue.custom_field_values = {field.id.to_s => "jsmith@somenet.foo"}
    issue.save

    assert_no_difference 'User.count' do
      assert_no_difference 'Issue.count' do
        assert_difference 'Journal.count' do
          assert_difference 'JournalDetail.count' do
            assert_difference 'Attachment.count' do
              journal = submit_email(
                  'ticket_with_attachment.eml',
                  :issue => {:project => 'onlinestore'},
                  :no_permission_check => '1',
                  :unknown_user => 'accept'
              )
              assert journal.is_a?(Journal)
              assert_equal journal.issue.author, author
            end
          end
        end
      end
    end
  end

  def test_receive_resolved_many
    field = IssueCustomField.create!(:name => 'order_email', :field_format => 'string', :is_for_all => true, :tracker_ids => [1,2,3])
    issue = Issue.find(1)
    email_sender = "john.doe@somenet.foo"
    issue.custom_field_values = {field.id.to_s => email_sender}
    issue.save
    issue = Issue.find(2)
    issue.custom_field_values = {field.id.to_s => email_sender}
    issue.save
    tracker = Tracker.find(3)

    with_settings :plugin_orders => {:order_email => field.name, :unresolved_tracker => tracker.name} do 
      assert_no_difference 'User.count' do
        assert_difference 'Issue.count' do
            issue = submit_email(
                'ticket_by_unknown_user.eml',
                :issue => {:project => 'onlinestore'},
                :no_permission_check => '1',
                :unknown_user => 'accept'
            )
            assert_equal issue.custom_field_value(field.id), email_sender
            assert issue.author.anonymous?
            assert_equal issue.tracker, tracker
        end
      end
    end
  end


  private

  def submit_email(filename, options={})
    raw = IO.read(File.join(FIXTURES_PATH, filename))
    yield raw if block_given?
    MailHandler.receive(raw, options)
  end
end
