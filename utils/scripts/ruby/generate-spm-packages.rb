require 'mustache'
require 'yaml'
require_relative './modules.rb'

# Mustache Templates
$spm_lib_template = File.dirname(__FILE__) + '/../../templates/spm-package/spm-lib.mustache'

# Modules
$libraries = libraries()

def generate_packages()
  lib_paths = $libraries.map { |lib| [lib.name, lib.path_lib] }.to_h

  # Hash map over packages and their paths to reference in Package.swift dependencies
  deps_paths = lib_paths

  $libraries.each do |lib|
    puts "Generating Package.swift for: #{lib.name}..."
    if (File.directory?(lib.path_lib))
      package_swift_lib = generate_package_swift_lib(lib, deps_paths, $external_dependencies)
      File.write("#{lib.path_lib}/Package.swift", package_swift_lib)
    end
  end
end

def get_local_packages(deps, deps_paths)
  deps
    .select{ |dep| deps_paths.key?(dep) }
    .uniq
    .map{ |dep| {"name" => dep, "path" => "../../../../#{deps_paths[dep]}"} }
end

def get_external_packages(deps, deps_paths, deps_external)
  deps
    .reject{ |dep| deps_paths.key?(dep) }
    .select{ |dep| deps_external.find{ |ext| ext.products.include? dep } }
    .uniq
    .map{ |dep|
      external_dep = deps_external.find{ |ext| ext.products.include? dep }
      { "name" => dep }.merge(external_dep.raw)
    }
end

def get_deps(deps, deps_paths, deps_external)
  local = get_local_packages(deps, deps_paths)
  .map{ |dep| { "name" => dep["name"], "package" => dep["name"] } }

  external = get_external_packages(deps, deps_paths, deps_external)
  .map{ |dep| { "name" => dep["name"], "package" => dep["package"] } }

  return local + external
end

def generate_package_swift_lib(lib, deps_paths, deps_external)
  return Mustache.render(
    File.read($spm_lib_template), 
    {
      'name' => lib.name,
      'platform_version_ios' => 16,
      'platform_version_watchos' => 9,
      'deps_lib' => get_deps(lib.deps_lib, deps_paths, deps_external),
      'deps_tests' => get_deps(lib.deps_tests, deps_paths, deps_external).reject{ |dep| dep["name"] == lib.name },
      'has_localization' => lib.localization,
      'has_tests' => File.directory?("#{lib.path_tests}"),
      'resources' => lib.resources.count() > 0 ? [{"array" => lib.resources}] : false,
      'packages' => get_local_packages(lib.deps_lib + lib.deps_tests, deps_paths).reject{ |dep| dep["name"] == lib.name },
      'packages_external' => get_external_packages(lib.deps_lib + lib.deps_tests, deps_paths, deps_external).uniq { |dep| dep["url"] },
    }
  )
end

generate_packages()
