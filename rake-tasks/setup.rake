# Default invocation for namespace
desc "Shorthand for setup:all"
task :setup => "setup:all"

# Scope related tasks under a namespace
namespace 'setup' do

  desc "(alias 'rake setup') Runs through all setup steps, run this on a clean checkout"
  task :all do
    sh 'rake setup:bundle'
    sh 'rake git:hooks:install'
    sh 'rake generate'
    puts ""
  end

  desc "Install bundle dependencies (gems)"
  task :bundle do
    puts "⏳ Installing bundle dependencies..."
    sh 'bundle install'
    puts "✅ Done"
  end

end