# Default invocation for namespace
task :generate => "generate:all"

namespace 'generate' do

    desc "Generate all"
    task :all do
        puts "-----------------------------"
        sh 'rake generate:modules'
        puts ""

        puts "-----------------------------"
        sh 'rake generate:codeowners'
        puts ""

        puts "-----------------------------"
        sh 'rake generate:project'
    end

    desc "Generate project files"
    task :project do
        puts "⏳ Generating project files..."
        sh 'bundle exec ruby utils/scripts/ruby/generate-modules-project-files.rb'
        puts "⏳ Generating Apps/Modules/Modules.xcodeproj"
        sh 'rake tools:xcodegen\["--spec $(pwd)/Apps/Modules/project.yaml"\]'
        puts "✅ Done"
    end

    desc "Generate all modules (alias 'rake generate')"
    task :modules do
        puts "⏳ Generating all modules..."
        sh 'bundle exec ruby utils/scripts/ruby/generate-spm-packages.rb'
        puts "✅ Done"
    end

    desc "Generate CODEOWNERS"
    task :codeowners do
        puts "⏳ Generating CODEOWNERS file from modules yaml files"
        # sh 'bundle exec ruby utils/scripts/ruby/generate-code-owners.rb'
        puts "✅ Done"
    end

end
