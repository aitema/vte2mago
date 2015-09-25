require 'test_helper'

class OrderItemRequestsControllerTest < ActionController::TestCase
  setup do
    @order_item_request = order_item_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_item_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_item_request" do
    assert_difference('OrderItemRequest.count') do
      post :create, order_item_request: {  }
    end

    assert_redirected_to order_item_request_path(assigns(:order_item_request))
  end

  test "should show order_item_request" do
    get :show, id: @order_item_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_item_request
    assert_response :success
  end

  test "should update order_item_request" do
    patch :update, id: @order_item_request, order_item_request: {  }
    assert_redirected_to order_item_request_path(assigns(:order_item_request))
  end

  test "should destroy order_item_request" do
    assert_difference('OrderItemRequest.count', -1) do
      delete :destroy, id: @order_item_request
    end

    assert_redirected_to order_item_requests_path
  end
end
