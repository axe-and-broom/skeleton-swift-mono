# Scope related tasks under a namespace
namespace 'ci' do

  desc "Hello World"
  task :hello_world do
    puts "⏳ Running..."
    puts "Hello World!"
    puts "✅ Done"
  end

end