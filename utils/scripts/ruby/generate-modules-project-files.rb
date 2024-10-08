require 'yaml'
require 'json'
require 'pathname'
require_relative './modules.rb'
require_relative './classes/XCTestPlan.rb'

$libraries = libraries()
$features = features()
$modules_project_absolute_path = Pathname.new(File.expand_path('Apps/Modules'))
$modules_generated_yaml_path = Pathname.new(File.expand_path('Apps/Modules/modules_generated.yaml'))
$modules_test_plan_path = Pathname.new(File.expand_path('Apps/Modules/Modules.xctestplan'))

def generate_modules_xcodegen_project
  puts "⏳ Generating xcodegen Apps/Modules/modules_generated.yaml..."
  modules_generated = {
    'packages' => generate_packages($libraries, $features),
    'targetTemplates' => {
      'ModulesApp' => {
        'type' => 'application',
        'dependencies' => generate_dependencies($libraries, $features)
      }
    }
  }

  File.open($modules_generated_yaml_path, 'w') { |file|
    file.write(modules_generated.to_yaml)
  }
  puts "✅ Done"
end

def generate_packages(libraries, features)
  libraries = $libraries.map { |library|
    {
      library.name => {
        'path' => library.path_lib,
        'group' => library.path
      }
    }
  }
  features = $features.map { |feature|
    [
      {
        feature.name => {
          'path' => feature.path_api,
          'group' => feature.path
        }
      },
      {
        feature.name_impl => {
          'path' => feature.path_impl,
          'group' => feature.path
        }
      },
      {
        feature.name_testutils => {
          'path' => feature.path_testutils,
          'group' => feature.path
        }
      }
    ]
  }
  .flatten

  packages = (libraries + features)
  .map { |package|
    name = package.keys[0]
    {
      name => {
        'path' => Pathname.new(File.expand_path(package[name]['path']))
        .relative_path_from($modules_project_absolute_path)
        .to_s,
        'group' => Pathname.new(File.expand_path(package[name]['group']))
        .relative_path_from($modules_project_absolute_path)
        .to_s
      }
    }
  }
  .to_h { |package|
    name = package.keys[0]
    [name, package[name]]
  }

  return packages
end

def generate_dependencies(libraries, features)
  libraries = libraries.map { |library|
    library.name
  }
  features = features.map { |feature|
    [
      feature.name,
      feature.name_impl
    ]
  }
  .flatten

  dependencies = (libraries + features)
  .map { |package|
    {
      'package' => package
    }
  }

  return dependencies
end

def generate_test_plan
  puts "⏳ Generating Modules.xctestplan..."

  libraries = $libraries.map { |library|
    path = Pathname.new(File.expand_path(library.path_lib))
    .relative_path_from($modules_project_absolute_path)
    .to_s
    enabled = File.directory?("#{library.path_lib}/Tests")
    XCTestPlanTestTarget.new(path, "#{library.name}Tests", enabled)
  }

  features = $features.map { |feature|
    path = Pathname.new(File.expand_path(feature.path_impl))
    .relative_path_from($modules_project_absolute_path)
    .to_s
    enabled = File.directory?("#{feature.path_impl}/Tests")
    XCTestPlanTestTarget.new(path, "#{feature.name_impl}Tests", enabled)
  }

  test_targets = (libraries + features).sort_by { |target| target.name }

  test_plan = XCTestPlan.new(
    'Modules',
    'Modules.xcodeproj',
    test_targets, 
    {}
  )

  File.open($modules_test_plan_path, 'w') { |file|
    file.write(JSON.pretty_generate(test_plan.to_object))
  }
  puts "✅ Done"
end

generate_modules_xcodegen_project
generate_test_plan
