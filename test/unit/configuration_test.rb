# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"

class ConfigurationTest < MiniTest::Test
  def test_validates_yaml
    config_file = File.expand_path("test/configs/valid_config.yml")
    Puptime::Configuration.new(file: config_file)
  end

  def test_raises_syntax_error_for_invalid_yaml
    config_file = File.expand_path("test/configs/invalid_config.yml")
    assert_raises Psych::SyntaxError do
      Puptime::Configuration.new(file: config_file)
    end
  end

  def test_raises_file_missing_error
    config_file = File.expand_path("test/configs/notfound_config.yml")
    assert_raises Puptime::Configuration::MissingFileError do
      Puptime::Configuration.new(file: config_file)
    end
  end

  def test_config_accessor
    config_file = File.expand_path("test/configs/valid_config.yml")
    assert Puptime::Configuration.new(file: config_file).respond_to? :config
  end
end
