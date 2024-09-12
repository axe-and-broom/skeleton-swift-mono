source "https://rubygems.org"

# Cross repo gems

# gem fastlane


# App Project Gemfiles
gem_files = Dir.glob(File.join(File.dirname(__FILE__), 'Apps/*/Gemfile'))
fastlane_plugin_files = Dir.glob(File.join(File.dirname(__FILE__), 'Apps/*/fastlane/Pluginfile'))
(gem_files + fastlane_plugin_files).each { |gemfile|
  eval_gemfile(gemfile)
}
