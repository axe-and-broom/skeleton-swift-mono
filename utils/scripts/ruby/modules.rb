require_relative './classes/Library.rb'
require_relative './classes/Feature.rb'

# Lazy loading modules

def libraries
  @libraries ||= Dir.glob('**/library.yaml').map{ |f| Library.new(f) }.sort_by{ |library| library.name }
end

def features
  @features ||= Dir.glob('**/feature.yaml').map{ |f| Feature.new(f) }.sort_by{ |feature| feature.name }
end
