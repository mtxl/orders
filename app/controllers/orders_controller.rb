class OrdersController < ApplicationController
  unloadable

  def import
    api_token = Setting.plugin_orders['orders_api_key']
    url = Setting.plugin_orders['orders_api_path']
    begin
      response = RestClient.get(url, :params => { :range => params[:order_id], :auth_token => api_token})
      redirect_to new_project_issue_path options_from_(response)
    rescue => e
      render inline: e.response
    end
  end

  private

  def options_from_(response)
    items = JSON.parse(response)
    item = items.first

    options = {
    "project_id" => 16,  
    "issue[subject]" => item["product_info"]["title"],
    "issue[custom_field_values][1]"  => item["user"]["email"],
    "issue[custom_field_values][13]" => item["user"]["contact_name"],
    "issue[custom_field_values][14]" => item["user"]["phone"],
    "issue[custom_field_values][6]"  => item["attendees"],
    "issue[custom_field_values][30]" => item["id"],
    "issue[custom_field_values][11]" => item["contractor"]["full_name"],
    "issue[custom_field_values][22]" => item["contractor"]["name"],
    "issue[custom_field_values][23]" => item["contractor"]["inn"],
    "issue[custom_field_values][20]" => item["contractor"]["office_email"],
    "issue[custom_field_values][26]" => item['contractor']['office_phone'],
    "issue[custom_field_values][12]" => item["contractor"]["postal_address"]
    } if item
  end
end
