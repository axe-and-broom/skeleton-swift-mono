# Default invocation for namespace
task :clean => "clean:soft"

# Scope related tasks under a namespace
namespace 'clean' do

  desc "Soft clean"
  task :soft do
    sh 'rake clean:dd'
    puts ""
    sh 'rake clean:spm'
    puts ""
    sh 'rake clean:vscode'
    puts ""
    sh 'rake clean:previews'
    puts ""
    sh 'rake clean:xcode'
    puts '🟠 Remember to run `rake setup`'
  end

  desc "Clean everything (destructive)"
  task :all do
    sh 'rake clean:ignored'
    puts ""
    sh 'rake clean:simulator'
    puts ""
    sh 'rake clean:ruby'
    puts ""
    sh 'rake clean:soft'
  end

  # Soft clean tasks
  #------------------

  desc "Clean derived data"
  task :dd do
    puts "⏳ Cleaning derived data cache..."
    sh "rm -rf ~/Library/Developer/Xcode/DerivedData"
    puts "✅ Done"
  end

  desc "Clean SPM cache"
  task :spm do
    puts "⏳ Cleaning SPM cache..."
    sh "rm -rf utils/vendor/SPM"
    sh "rm -rf ~/Library/Caches/org.swift.swiftpm"
    puts "✅ Done"
  end

  desc "Clean VSCode cache"
  task :vscode do
    puts "⏳ Cleaning VSCode cache..."
    sh "rm -rf ~/Library/Application Support/Code/CachedData/"
    sh "rm -rf ~/Library/Application Support/Code/User/workspaceStorage/"
    puts "✅ Done"
  end

  desc "Clean SwiftUI previews"
  task :previews do
    puts "⏳ Cleaning SwiftUI previews cache..."
    sh "rm -rf ~/Library/Developer/CoreSimulator/Caches"
    puts "✅ Done"
  end

  desc "Clean Xcode application state"
  task :xcode do
    puts "⏳ Cleaning Xcode application state..."
    sh "rm -rf  ~/Library/Saved\ Application\ State/com.apple.dt.Xcode.savedState"
    puts "✅ Done"
  end

  # Hard clean tasks
  #------------------

  desc "Clean git ignored files, warning this could be destructive"
  task :ignored do
    puts "⏳ Cleaning git ignored files, this could be destructive"
    # -d Directories
    # -f Force
    # -X Remove only ignored files
    sh "git clean -dfX"
    puts "✅ Done"
  end

  desc "Clean simulators"
  task :simulator do
    puts "⏳ Cleaning simulators..."
    sh "xcrun simctl shutdown all"
    sh "xcrun simctl erase all"
    puts "✅ Done"
  end

  desc "Clean local ruby gems (remember to run `rake setup` after!)"
  task :ruby do
    puts "⏳ Cleaning local ruby gems..."
    sh "rm -rf utils/vendor/ruby"
    puts "✅ Done"
  end

end
