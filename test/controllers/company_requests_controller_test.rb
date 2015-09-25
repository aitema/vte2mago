require 'test_helper'

class CompanyRequestsControllerTest < ActionController::TestCase
  setup do
    @company_request = company_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:company_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company_request" do
    assert_difference('CompanyRequest.count') do
      post :create, company_request: {  }
    end

    assert_redirected_to company_request_path(assigns(:company_request))
  end

  test "should show company_request" do
    get :show, id: @company_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company_request
    assert_response :success
  end

  test "should update company_request" do
    patch :update, id: @company_request, company_request: {  }
    assert_redirected_to company_request_path(assigns(:company_request))
  end

  test "should destroy company_request" do
    assert_difference('CompanyRequest.count', -1) do
      delete :destroy, id: @company_request
    end

    assert_redirected_to company_requests_path
  end
end
