# Default invocation for namespace
desc "Shorthand for setup:all"
task :setup => "setup:all"

# Scope related tasks under a namespace
namespace 'setup' do

  desc "Setup everything for the app"
  task :all do
    sh 'rake app1:setup:hello_world'
    puts ""
  end

  desc "Hello World"
  task :hello_world do
    puts "⏳ Running..."
    puts "Hello World!"
    puts "✅ Done"
  end

end