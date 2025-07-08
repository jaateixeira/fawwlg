#!/bin/bash

# --- Config ---
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
HISTORY_DIR=".git_history_backup"
REMOTE_NAME="origin"

# --- Safety Check ---
if [ ! -d .git ]; then
    echo "Error: Not a Git repository!" >&2
    exit 1
fi

# --- Step 1: Backup all branch logs ---
mkdir -p "$HISTORY_DIR"
for branch in $(git branch --format='%(refname:short)'); do
    git log --graph --pretty=format:'%h - %s (%an, %ar)' "$branch" > "$HISTORY_DIR/history_${branch}_${TIMESTAMP}.md"
done

# --- Step 2: Create new orphan commits for each branch ---
git checkout --quiet --detach  # Detach HEAD to avoid branch conflicts
for branch in $(git branch --format='%(refname:short)'); do
    echo "Processing branch: $branch"
    
    # Checkout branch and get its latest files
    git checkout --quiet "$branch"
    FILES_HASH=$(git stash create)  # Save worktree without commits
    
    # Create new orphan branch
    git checkout --quiet --orphan "new_$branch"
    if [ -n "$FILES_HASH" ]; then
        git stash apply --quiet "$FILES_HASH"  # Restore files
    fi
    git add -A
    git commit -m "Reset history ($TIMESTAMP) - based on '$branch'"
    
    # Preserve history file
    cp "$HISTORY_DIR/history_${branch}_${TIMESTAMP}.md" "HISTORY_${branch}.md"
    git add "HISTORY_${branch}.md"
    git commit --amend --no-edit  # Append history without extra commit
done

# --- Step 3: Replace old branches with new ones ---
for branch in $(git branch --format='%(refname:short)'); do
    git branch -D "$branch"                     # Delete old branch
    git branch -m "$branch" "new_$branch"       # Rename new branch
done

# --- Step 4: Force-push all branches to remote ---
echo -e "\n\033[1;31mWARNING: This will overwrite ALL remote branches!\033[0m"
read -p "Force-push to '$REMOTE_NAME'? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push --all --force "$REMOTE_NAME"
    git push --tags --force "$REMOTE_NAME"
    echo -e "\n\033[1;32mDone! All branches updated.\033[0m"
else
    echo -e "\n\033[1;33mAborted. Remote unchanged.\033[0m"
fi

echo "This script rewrites Git history and force-pushes all branches."
echo "Anyone with a local clone will lose sync with the remote."
echo "All team members must reclone"
