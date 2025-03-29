#!/bin/bash
#shx Standard Utility
# Remove useless files
tree -iafl --gitignore | grep "\.swp$" | while IFS= read -r file; do
	if [ -f "$file" ]; then
		rm -v "$file"
	fi
done
# Push to a single remote
git stage -A && git commit && git push $1
# Push to all remotes
#git stage -A && git commit && git remote | xargs -L1 git push
exit
