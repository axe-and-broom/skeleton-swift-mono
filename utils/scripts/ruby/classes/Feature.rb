require 'yaml'
require 'pathname'
require_relative './ModuleProtocol.rb'

class Feature
  include ModuleProtocol

  def initialize(yaml_path)
    super(yaml_path)
  end

  # Feature specific - Name
  # ----------------------------

  def name_api
    "#{self.name}API"
  end

  def name_impl
    "#{self.name}Impl"
  end

  def name_testutils
    "#{self.name}TestUtils"
  end

  # Feature specific - Path
  # ----------------------------

  def path_api
    "#{@path_folder}/#{self.name_api}"
  end

  def path_impl
    "#{@path_folder}/#{self.name_impl}"
  end

  def path_tests
    "#{@path_folder}/#{self.name_impl}/Tests"
  end

  def path_testutils
    "#{@path_folder}/#{self.name_testutils}"
  end


  # Feature specific - Deps
  # ----------------------------

  def api_deps
    (@raw["dependencies"]["api"] || [])
    .sort
  end

  def impl_deps
    (
      [self.name] + 
      (@raw["dependencies"]["impl"] || [])
    )
    .sort
  end
  
  def test_deps
    (
      [self.name, self.name_impl, self.name_testutils] + 
      (@raw["dependencies"]["tests"] || [])
    )
    .sort
  end
  
  def testutils_deps
    (
      [self.name] + 
      (@raw["dependencies"]["test-utils"] || [])
    )
    .sort
  end
  
end
