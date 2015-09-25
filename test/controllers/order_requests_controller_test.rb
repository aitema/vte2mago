require 'test_helper'

class OrderRequestsControllerTest < ActionController::TestCase
  setup do
    @order_request = order_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_request" do
    assert_difference('OrderRequest.count') do
      post :create, order_request: {  }
    end

    assert_redirected_to order_request_path(assigns(:order_request))
  end

  test "should show order_request" do
    get :show, id: @order_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_request
    assert_response :success
  end

  test "should update order_request" do
    patch :update, id: @order_request, order_request: {  }
    assert_redirected_to order_request_path(assigns(:order_request))
  end

  test "should destroy order_request" do
    assert_difference('OrderRequest.count', -1) do
      delete :destroy, id: @order_request
    end

    assert_redirected_to order_requests_path
  end
end
