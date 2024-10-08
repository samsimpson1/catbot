require "yaml"

class Config
  def self.load_config
    config_file = ENV.fetch("CONFIG_FILE", "config.yaml")
    return YAML.load_file(config_file)
  end

  @@config = load_config

  def self.[](key)
    return @@config[key]
  end
end