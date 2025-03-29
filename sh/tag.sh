#!/bin/bash
git tag -a "$1" "${2:-HEAD}" && git push origin "$1"
exit