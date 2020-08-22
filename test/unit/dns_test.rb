# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"

class DnsTest < MiniTest::Test
  def setup
    Puptime::Logging.logger
  end

  def test_initialises_with_mandatory_service_params
    dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                            { "record_type" => "NS", "resource" => "google.com",
                                                      "results" => "ns3.google.com, ns4.google.com, ns2.google.com" })
    assert_equal "name", dns_service.name
    assert_equal "5", dns_service.interval
  end

  def test_initialises_with_dns_params
    dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                            { "record_type" => "NS", "resource" => "google.com",
                                              "results" => "ns3.google.com, ns4.google.com, ns2.google.com" })
    assert_equal "google.com", dns_service.resource
    assert_equal :NS, dns_service.record_type
    assert_equal ["ns3.google.com", "ns4.google.com", "ns2.google.com"], dns_service.results
  end

  def test_raises_error_without_dns_params
    assert_raises Puptime::Service::ParamMissingError do
      dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                              { "resource" => "google.com",
                                                "results" => "ns3.google.com, ns4.google.com, ns2.google.com" })
    end

    assert_raises Puptime::Service::ParamMissingError do
      dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                              { "record_type" => "NS",
                                                "results" => "ns3.google.com, ns4.google.com, ns2.google.com" })
    end

    assert_raises Puptime::Service::ParamMissingError do
      dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                              { "results" => "ns3.google.com, ns4.google.com, ns2.google.com" })
    end
  end

  def test_resource_name
    dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                            { "record_type" => "NS", "resource" => "google.com", "match" => "true",
                                              "results" => "ns3.google.com, ns4.google.com, ns2.google.com" })
    assert_equal "google.com#NS ==> [\"ns3.google.com\", \"ns4.google.com\", \"ns2.google.com\"]", dns_service.resource_name
  end

  def test_dns_ping
    dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                            { "record_type" => "NS", "resource" => "google.com", "match" => "true",
                                              "results" => "ns3.google.com, ns4.google.com, ns2.google.com, ns1.google.com" })
    dns_service.stub :ping, :success do
      assert_equal :success, dns_service.ping
    end

    dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                            { "record_type" => "NS", "resource" => "facebook.com", "match" => "true",
                                              "results" => "ns3.google.com, ns4.google.com, ns2.google.com, ns1.google.com" })
    assert_equal :failure, dns_service.ping
  end

  def test_error_level_raise
    dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                            { "record_type" => "NS", "resource" => "facebook.com", "match" => "true",
                                              "results" => "ns3.google.com, ns4.google.com, ns2.google.com, ns1.google.com" })
    initial_error_level = dns_service.error_level
    dns_service.ping
    error_change = dns_service.error_level - initial_error_level
    assert_equal 1, error_change
  end

  def test_not_raise_above_3
    dns_service = Puptime::Service::DNS.new("name", "id", "DNS", "5",
                                            { "record_type" => "NS", "resource" => "facebook.com", "match" => "true",
                                              "results" => "ns3.google.com, ns4.google.com, ns2.google.com, ns1.google.com" })
    initial_error_level = dns_service.error_level
    4.times { dns_service.ping }
    error_change = dns_service.error_level - initial_error_level
    assert_equal 3, error_change
  end
end
