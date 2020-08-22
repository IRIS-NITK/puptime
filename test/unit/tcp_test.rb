# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "socket"

class TcpTest < MiniTest::Test
  def setup
    Puptime::Logging.logger
    begin
      server = TCPServer.new 3000
    rescue Errno::EADDRINUSE
      # Ignored
    end
  end

  def test_initialises_with_mandatory_service_params
    tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 80, "ip_addr" => "localhost" })
    assert_equal "name", tcp_service.name
    assert_equal "5", tcp_service.interval
  end

  def test_initialises_with_tcp_params
    tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 80, "ip_addr" => "localhost" })
    assert_equal 80, tcp_service.port
    assert_equal "localhost", tcp_service.ip_addr
  end

  def test_raises_error_without_port
    assert_raises Puptime::Service::ParamMissingError do
      tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "ip_addr" => "localhost" })
    end
  end

  def test_raises_error_without_ip
    assert_raises Puptime::Service::ParamMissingError do
      tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 80 })
    end
  end

  def test_resource_name
    tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 80, "ip_addr" => "localhost" })
    assert_equal "localhost:80", tcp_service.resource_name
  end

  def test_tcp_ping
    tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 3000, "ip_addr" => "localhost" })
    assert_equal :success, tcp_service.ping

    tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 8889, "ip_addr" => "localhost" })
    assert_equal :failure, tcp_service.ping
  end

  def test_error_level_raise
    tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 8880, "ip_addr" => "localhost" })
    initial_error_level = tcp_service.error_level
    tcp_service.ping
    error_change = tcp_service.error_level - initial_error_level
    assert_equal 1, error_change
  end

  def test_not_raise_above_3
    tcp_service = Puptime::Service::TCP.new("name", "id", "TCP", "5", { "port" => 8880, "ip_addr" => "localhost" })
    initial_error_level = tcp_service.error_level
    4.times { tcp_service.ping }
    error_change = tcp_service.error_level - initial_error_level
    assert_equal 3, error_change
  end
end
