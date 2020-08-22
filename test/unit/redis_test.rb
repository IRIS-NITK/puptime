# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "socket"

class RedisTest < MiniTest::Test
  def setup
    Puptime::Logging.logger
  end

  def test_initialises_with_mandatory_service_params
    redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "ip_addr" => "localhost", "db" => 15 })
    assert_equal "name", redis_service.name
    assert_equal "5", redis_service.interval
  end

  def test_initialises_with_redis_params
    redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "ip_addr" => "localhost", "db" => 15 })
    assert_equal 6379, redis_service.port
    assert_equal "localhost", redis_service.ip_addr
  end

  def test_raises_error_without_port
    assert_raises Puptime::Service::ParamMissingError do
      redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "ip_addr" => "localhost", "db" => 15 })
    end
  end

  def test_raises_error_without_ip
    assert_raises Puptime::Service::ParamMissingError do
      redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "db" => 15 })
    end
  end

  def test_resource_name
    redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "ip_addr" => "localhost", "db" => 15 })
    assert_equal "localhost:6379/15", redis_service.resource_name
  end

  def test_redis_ping
    redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "ip_addr" => "localhost", "db" => 15 })
    redis_service.stub :ping, :success do
      assert_equal :success, redis_service.ping
    end

    redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "ip_addr" => "localhost", "db" => 15 })
    assert_equal :failure, redis_service.ping
  end

  def test_error_level_raise
    redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "ip_addr" => "localhost", "db" => 15 })
    initial_error_level = redis_service.error_level
    redis_service.ping
    error_change = redis_service.error_level - initial_error_level
    assert_equal 1, error_change
  end

  def test_not_raise_above_3
    redis_service = Puptime::Service::Redis.new("name", "id", "Redis", "5",
                                                { "port" => 6379, "ip_addr" => "localhost", "db" => 15 })
    initial_error_level = redis_service.error_level
    4.times { redis_service.ping }
    error_change = redis_service.error_level - initial_error_level
    assert_equal 3, error_change
  end
end
