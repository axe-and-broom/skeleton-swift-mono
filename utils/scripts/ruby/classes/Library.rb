require 'yaml'
require 'pathname'
require_relative './ModuleProtocol.rb'

class Library
  include ModuleProtocol

  def initialize(yaml_path)
    super(yaml_path)
  end

  # Lib specific
  # ----------------------------

  def name_lib
    "#{self.name}Lib"
  end

  def path_lib
    "#{@path_folder}/#{self.name_lib}"
  end

  def deps_lib
    (@raw["dependencies"]["lib"] || [])
    .sort
  end

  # Implemented Module Test Paths
  # ----------------------------

  def path_tests
    "#{@path_folder}/#{self.name_lib}/Tests"
  end

  def deps_tests
    (
      [self.name] + 
      (@raw["dependencies"]["tests"] || [])
    )
    .sort
  end
  
end
