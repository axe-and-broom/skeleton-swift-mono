# Default invocation for namespace
desc "Shorthand for lint:all"
task :lint => "lint:all"

# Scope related tasks under a namespace
namespace 'lint' do

  task :all do
    sh "rake lint:files"
    puts ""
  end

  desc "Lints all files"
  task :files, [:rule] do |t, args|
    puts "⏳ Linting files..."
    status = system "bundle exec ruby utils/scripts/ruby/lint-files.rb #{args[:rule]}"
    if !status
      puts "❌ Failed"
      exit(1)
    end
    puts "✅ Done"
  end
  
end
