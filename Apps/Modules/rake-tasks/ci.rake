# Scope related tasks under a namespace
namespace 'ci' do

  desc "Build for testing"
  task :build_for_testing do
    puts "⏳ Building for testing..."
    sh "set -o pipefail && cd Apps/Modules && xcodebuild build-for-testing -scheme Modules -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' | bundle exec xcpretty -r junit"
    puts "✅ Done"
  end

  desc "Build and run unit tests"
  task :test do
    puts "⏳ Building and running tests..."
    sh "set -o pipefail && cd Apps/Modules && xcodebuild test -scheme Modules -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' | bundle exec xcpretty -r junit"
    puts "✅ Done"
  end

end