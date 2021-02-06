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

(
    echo "Preparing VM ..."

    cd pytch-vm
    (
        npm install
        npm run devbuild
        ( cd dist; ln -s skulpt.js skulpt.min.js )
    ) > "$REPO_ROOT"/pytch-vm-preparation.out 2> "$REPO_ROOT"/pytch-vm-preparation.err

    echo "Prepared VM"
) &

(
    echo "Preparing build tools ..."

    cd pytch-build

    (
        virtualenv -p python3 venv \
            && source venv/bin/activate \
            && pip install -r requirements_dev.txt \
            && python setup.py install
    ) > "$REPO_ROOT"/pytch-build-preparation.out 2> "$REPO_ROOT"/pytch-build-preparation.err

    echo "Prepared build tools"
) &

(
    echo "Preparing webapp ..."

    cd pytch-webapp

    (
        npm install
    ) > "$REPO_ROOT"/pytch-webapp-preparation.out 2> "$REPO_ROOT"/pytch-webapp-preparation.err

    echo "Prepared webapp"
) &

wait
echo "Built all; see *-preparation.(out|err) for details"
