#!/bin/bash

REPO_ROOT="$(dirname "$(realpath "$0")")"
cd "$REPO_ROOT"

git submodule --quiet init
git submodule --quiet update

for part in pytch-build pytch-vm pytch-webapp pytch-website; do
    (
        cd $part
        git checkout --quiet develop
    )
done

(
    cd pytch-tutorials
    git checkout --quiet release-recipes
)

./pytch-build/makesite/pytch-git-status.sh
