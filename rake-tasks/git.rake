namespace 'git' do
    namespace 'hooks' do
      desc "Install git hooks"
      task :install do
        puts "⏳ Installing git hooks..."
        sh "utils/scripts/git-hooks/install-git-hooks.sh"
        puts "✅ Done"
      end
    end
  end
  