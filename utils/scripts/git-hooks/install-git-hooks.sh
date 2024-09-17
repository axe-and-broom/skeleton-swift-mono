#!/bin/bash

echo "⏳ Installing all git hooks from './utils/git-hooks/*'"

HOOKS=$(find utils/git-hooks -type f ! -name "?*.*")
for HOOK_PATH in $HOOKS
do
  HOOK=$(basename $HOOK_PATH)
    # Remove existing git hook (if any)
    rm -f .git/hooks/$HOOK
    
    # Symlink hook to utils/git-hooks/$HOOK
    ln -s ../../utils/git-hooks/$HOOK .git/hooks/$HOOK
    chmod 755 .git/hooks/$HOOK
    echo "✅ $HOOK"
done

echo "🎉 All Done"