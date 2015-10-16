require File.expand_path('../../test_helper', __FILE__)

class OrdersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_order_get
    get :get
    assert_response :success
    assert_template  'orders/get'
    assert_select "form[method=post][action=?]", "/import"
    assert_select 'input[id=order_id]'
  end

  def test_order_import
    resp = [{id: 1, attendees: "Ivanov", contractor: {}, user: {}, product_info: {title: "The best product"}}].to_json
    RestClient.expects(:get).returns(resp)
    Issue.any_instance.stubs(:save).returns(true)
    post :import, :order_id => 1
    assert_response :success
  end
end
