echo "Commit message"
read CommitMessage

git add -A
git commit -m "$CommitMessage"
git push
