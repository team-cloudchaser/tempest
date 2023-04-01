#!/bin/bash
git stage -A && git commit --amend && git remote | xargs -L1 git push --force
exit
