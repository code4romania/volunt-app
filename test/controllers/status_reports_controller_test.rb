require 'test_helper'

class StatusReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @status_report = status_reports(:one)
  end

  test "should get index" do
    get status_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_status_report_url
    assert_response :success
  end

  test "should create status_report" do
    assert_difference('StatusReport.count') do
      post status_reports_url, params: { status_report: {  } }
    end

    assert_redirected_to status_report_url(StatusReport.last)
  end

  test "should show status_report" do
    get status_report_url(@status_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_status_report_url(@status_report)
    assert_response :success
  end

  test "should update status_report" do
    patch status_report_url(@status_report), params: { status_report: {  } }
    assert_redirected_to status_report_url(@status_report)
  end

  test "should destroy status_report" do
    assert_difference('StatusReport.count', -1) do
      delete status_report_url(@status_report)
    end

    assert_redirected_to status_reports_url
  end
end
