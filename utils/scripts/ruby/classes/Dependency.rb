require 'yaml'
require 'pathname'

class Dependency

  def initialize(obj)
    @raw = obj
  end

  def package
    @raw["package"]
  end

  def products
    @raw["products"]
  end

  def owner
    @raw["owner"]
  end

  def url
    @raw["url"]
  end

  def revision
    @raw["revision"]
  end

  def version
    @raw["version"]
  end

  def raw
    @raw
  end

end
