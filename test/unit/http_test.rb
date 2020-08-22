# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "socket"

class HttpTest < MiniTest::Test
  def setup
    Puptime::Logging.logger
  end

  def test_initialises_with_mandatory_service_params
    http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                                { "url" => "google.com", "request-method" => "GET",
                                                  "response-code" => 200, "follow-redirect" => true })
    assert_equal "name", http_service.name
    assert_equal "5", http_service.interval
  end

  def test_initialises_with_http_params
    http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                              { "url" => "google.com", "request-method" => "GET",
                                                       "response-code" => 200, "follow-redirect" => true })
    assert_equal :get, http_service.request_method
    assert_equal "google.com", http_service.url
  end

  def test_raises_error_without_url
    assert_raises Puptime::Service::ParamMissingError do
      http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                                {"request-method" => "GET",
                                                         "response-code" => 200, "follow-redirect" => true })
    end
  end

  def test_raises_error_without_response_code
    assert_raises Puptime::Service::ParamMissingError do
      http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                                {"url" => "google.com",
                                                 "response-code" => 200, "follow-redirect" => true })
    end
  end

  def test_raises_error_without_respond_method
    assert_raises Puptime::Service::ParamMissingError do
      http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                                {"url" => "google.com",
                                                 "response-method" => "GET", "follow-redirect" => true })
    end
  end

  def test_resource_name
    http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                              { "url" => "google.com", "request-method" => "GET",
                                                       "response-code" => 200, "follow-redirect" => true })
    assert_equal "GET google.com", http_service.resource_name
  end

  def test_http_ping
    http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                              { "url" => "google.com", "request-method" => "GET",
                                                       "response-code" => 200, "follow-redirect" => true })
    http_service.stub :ping, :success do
      assert_equal :success, http_service.ping
    end

    http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                              { "url" => "puptime.com", "request-method" => "GET",
                                                       "response-code" => 200, "follow-redirect" => true })
    assert_equal :failure, http_service.ping
  end

  def test_error_level_raise
    http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                              { "url" => "puptime.com", "request-method" => "GET",
                                                       "response-code" => 200, "follow-redirect" => true })
    initial_error_level = http_service.error_level
    http_service.ping
    error_change = http_service.error_level - initial_error_level
    assert_equal 1, error_change
  end

  def test_not_raise_above_3
    http_service = Puptime::Service::HTTP.new("name", "id", "HTTP", "5",
                                              { "url" => "puptime.com", "request-method" => "GET",
                                                "response-code" => 200, "follow-redirect" => true })
    initial_error_level = http_service.error_level
    4.times { http_service.ping }
    error_change = http_service.error_level - initial_error_level
    assert_equal 3, error_change
  end
end
