class OrdersController < ApplicationController
  unloadable

  def import
    if create_issue_from(order_response)
      redirect_to edit_issue_path @issue
    else
      redirect_to orders_path
    end
  end

  private

  def order_response
    api_token = Setting.plugin_orders['orders_api_key']
    url = Setting.plugin_orders['orders_api_path']
    resp = RestClient.get(url, :params => { :range => params[:order_id], :auth_token => api_token})
  end

  def create_issue_from(resp)
    items = JSON.parse(resp)
    item = items.first
    if item
      build_issue_from(item)
      if @issue.save
        return true
      else
        flash[:error] = @issue.errors.empty? ? "Error" : @issues.errors.full_messages.to_sentence
        return false
      end
    else
      flash[:error] = l(:order_params_error)
      return false
    end
  end

  def build_issue_from(item)
    options = {
      "project_id" => 16,  
      "subject" => item["product_info"]["title"],
      "tracker_id" => 4,
      "author" => User.find_by_login("uri"),
      "order_info" => item
      }
    options.merge!("custom_field_values" => custom_fields(item))
    @issue = Issue.new(options)
  end

  def custom_fields(item)
    cf = {
      "1"  => item["user"]["email"],
      "13" => item["user"]["contact_name"],
      "14" => item["user"]["phone"],
      "6"  => item["attendees"],
      "11" => item["contractor"]["full_name"],
      "22" => item["contractor"]["name"],
      "23" => item["contractor"]["inn"],
      "20" => item["contractor"]["office_email"],
      "26" => item['contractor']['office_phone'],
      "12" => item["contractor"]["postal_address"]
    }
  end
end
