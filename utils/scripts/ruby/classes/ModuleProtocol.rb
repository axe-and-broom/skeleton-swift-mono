require 'yaml'
require 'pathname'

module ModuleProtocol
  def initialize(yaml_path)
    puts "Loading module: #{yaml_path}"
    @yaml_path = yaml_path
    @path_folder = Pathname.new(yaml_path).split.first.to_s
    @raw = YAML.load_file(yaml_path)
  end

  # YAML keys
  # ----------------------------

  def name
    @raw["name"]
  end

  def description
    @raw["description"]
  end

  def lifecycle
    @raw["lifecycle"]
  end

  def localization
    @raw["localization"] || false
  end

  def owner
    @raw["owner"]
  end

  def resources
    (@raw["resources"] || [])
  end

  # Module paths
  # ----------------------------

  def domain
    @path_folder.split('/')[-2]
  end

  def path
    "#{@path_folder}"
  end

  # Module Test
  # ----------------------------

  def path_tests
    raise NotImplementedError, "#{self.class} must implement #{__method__} the method"
  end

  def deps_tests
    raise NotImplementedError, "#{self.class} must implement #{__method__} the method"
  end
  
end
