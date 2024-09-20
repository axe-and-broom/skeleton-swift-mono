require 'mustache'
require 'yaml'
require_relative './modules.rb'
require_relative './classes/Dependency.rb'

# Mustache Templates
$spm_lib_template = File.read(File.dirname(__FILE__) + '/../../templates/spm-package/spm-lib.mustache')
$spm_feature_api_template = File.read(File.dirname(__FILE__) + '/../../templates/spm-package/spm-api.mustache')
$spm_feature_impl_template = File.read(File.dirname(__FILE__) + '/../../templates/spm-package/spm-impl.mustache')
$spm_feature_testutils_template = File.read(File.dirname(__FILE__) + '/../../templates/spm-package/spm-testutils.mustache')
$external_dependencies = YAML.load_file('Modules/dependencies.yaml').map{ |d| Dependency.new(d) }.sort_by{ |dep| dep.package }

# Modules
$libraries = libraries()
$features = features()

# Main function
# ----------------------------

def generate_packages()
  lib_paths = $libraries.map { |lib| [lib.name, lib.path_lib] }.to_h
  feature_api_paths = $features.map { |feature| [feature.name, feature.path_api] }.to_h # Using name instead of name_api to make imports prettier
  feature_impl_paths = $features.map { |feature| [feature.name_impl, feature.path_impl] }.to_h
  feature_testutils_paths = $features.map { |feature| [feature.name_testutils, feature.path_testutils] }.to_h

  # Hash map over packages and their paths to reference in Package.swift dependencies
  package_paths = lib_paths.merge(feature_api_paths).merge(feature_impl_paths).merge(feature_testutils_paths)

  $libraries.each do |lib|
    puts "Generating Package.swift for: #{lib.name}..."
    if (File.directory?(lib.path_lib))
      package_swift_lib = generate_spm_lib(lib, package_paths, $external_dependencies)
      File.write("#{lib.path_lib}/Package.swift", package_swift_lib)
    end
  end

  $features.each do |feature|
    puts "Generating package definitions for: #{feature.name}..."
    if (File.directory?(feature.path_api))
      package_swift_api = generate_spm_feature_api(feature, package_paths, $external_dependencies)
      File.write("#{feature.path_api}/Package.swift", package_swift_api)
    end

    if (File.directory?(feature.path_impl))
      package_swift_impl = generate_spm_feature_impl(feature, package_paths, $external_dependencies)
      File.write("#{feature.path_impl}/Package.swift", package_swift_impl)
    end

    if (File.directory?(feature.path_testutils))
      package_swift_testutils = generate_spm_feature_testutils(feature, package_paths, $external_dependencies)
      File.write("#{feature.path_testutils}/Package.swift", package_swift_testutils)
    end
  end

end

# Generate from Mustache templates
# ----------------------------

def generate_spm_lib(lib, package_paths, deps_external)
  return Mustache.render(
    $spm_lib_template,
    {
      'platform_version_ios' => 16,
      'platform_version_watchos' => 9,
      'name' => lib.name,
      'deps_lib' => get_deps(lib.deps_lib, package_paths, deps_external),
      'deps_tests' => get_deps(lib.deps_tests, package_paths, deps_external).reject{ |dep| dep["name"] == lib.name },
      'has_localization' => lib.localization,
      'has_tests' => File.directory?("#{lib.path_tests}"),
      'resources' => lib.resources.count() > 0 ? [{"array" => lib.resources}] : false,
      'packages' => get_local_packages(lib.deps_lib + lib.deps_tests, package_paths).reject{ |dep| dep["name"] == lib.name },
      'packages_external' => get_external_packages(lib.deps_lib + lib.deps_tests, package_paths, deps_external).uniq { |dep| dep["url"] },
    }
  )
end

def generate_spm_feature_api(feature, package_paths, deps_external)
  return Mustache.render(
    $spm_feature_api_template,
    {
      'platform_version_ios' => 16,
      'platform_version_watchos' => 9,
      'name' => feature.name,
      'api_deps' => get_deps(feature.deps_api, package_paths, deps_external),
      'packages' => get_local_packages(feature.deps_api, package_paths),
      'packages_external' => get_external_packages(feature.deps_api, package_paths, deps_external).uniq { |dep| dep["url"] },
    }
  )
end

def generate_spm_feature_impl(feature, package_paths, deps_external)
  return Mustache.render(
    $spm_feature_impl_template,
    {
      'platform_version_ios' => 16,
      'platform_version_watchos' => 9,
      'name' => feature.name,
      'impl_deps' => get_deps(feature.deps_impl, package_paths, deps_external),
      'test_deps' => get_deps(feature.deps_tests, package_paths, deps_external).reject{ |dep| dep["name"] == feature.name_impl },
      'has_localization' => feature.localization,
      'has_tests' => File.directory?("#{feature.path_impl}/Tests"),
      'resources' => feature.resources.count() > 0 ? [{"array" => feature.resources}] : false,
      'packages' => get_local_packages(feature.deps_impl + feature.deps_tests, package_paths).reject{ |dep| dep["name"] == feature.name_impl },
      'packages_external' => get_external_packages(feature.deps_impl + feature.deps_tests, package_paths, deps_external).uniq { |dep| dep["url"] },
    }
  )
end

def generate_spm_feature_testutils(feature, package_paths, deps_external)
  return Mustache.render(
    $spm_feature_testutils_template,
    {
      'platform_version_ios' => 16,
      'platform_version_watchos' => 9,
      'name' => feature.name,
      'testutils_deps' => get_deps(feature.deps_testutils, package_paths, deps_external),
      'packages' => get_local_packages(feature.deps_testutils, package_paths),
      'packages_external' => get_external_packages(feature.deps_testutils, package_paths, deps_external).uniq { |dep| dep["url"] },
    }
  )
end

# Helper functions
# ----------------------------

def get_local_packages(packages, package_paths)
  packages
    .select{ |dep| package_paths.key?(dep) }
    .uniq
    .map{ |dep| {"name" => dep, "path" => "../../../../#{package_paths[dep]}"} }
end

def get_external_packages(packages, package_paths, external_packages)
  packages
    .reject{ |dep| package_paths.key?(dep) }
    .select{ |dep| external_packages.find{ |ext| ext.products.include? dep } }
    .uniq
    .map{ |dep|
      external_dep = external_packages.find{ |ext| ext.products.include? dep }
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

# Run
generate_packages()
