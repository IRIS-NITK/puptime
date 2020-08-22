# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"

class ServiceSetTest < MiniTest::Test
  def setup
    config_file = File.expand_path("test/configs/valid_config.yml")
    @config = Puptime::Configuration.new(file: config_file).config
  end

  def test_with_correct_config
    serviceset = Puptime::ServiceSet.new(@config["monitors"])
    assert serviceset.respond_to? :services
  end

  def test_with_missing_parameter
    @config["monitors"][0].delete("name")
    assert_raises Puptime::ServiceSet::MissingParams do
      Puptime::ServiceSet.new(@config["monitors"])
    end
  end

  def test_with_unknown_service
    unknown_service = @config["monitors"][0]
    unknown_service["type"] = "UNKNOWN"
    @config["monitors"] << unknown_service
    assert_raises Puptime::ServiceSet::ServiceNotAvailable do
      Puptime::ServiceSet.new(@config["monitors"])
    end
  end

  def test_single_scheduler_initialized
    services = Puptime::ServiceSet.new(@config["monitors"]).services
    scheduler = services.first.scheduler
    services.each do |service|
      assert_equal scheduler, service.scheduler
    end
  end
end
