#!/bin/bash
git stage -A && git commit && git remote | xargs -L1 git push
exit
