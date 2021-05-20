#!/bin/bash

########################################################################
#
# Check required (versions of) tools are available

for tool in node git virtualenv python3; do
    if ! hash "$tool" 2> /dev/null; then
        echo Could not find "$tool"
        exit 1
    fi
done

node_version=$(node --version)
if [ $(echo $node_version | grep -c -E \^v14\\.) -ne 1 ]; then
    echo Need node v14 but have $node_version
    exit 1
fi


########################################################################

REPO_ROOT="$(dirname "$(realpath "$0")")"
cd "$REPO_ROOT"

echo "Initialising submodules ..."

git submodule --quiet init
git submodule --quiet update

echo "Initialised submodules"

for part in pytch-build pytch-vm pytch-webapp pytch-website; do
    (
        cd $part
        git checkout --quiet develop
    )
done

(
    echo "Preparing tutorials repo ..."

    cd pytch-tutorials
    git checkout --quiet release-recipes

    echo "Prepared tutorials repo"
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

echo
echo "Built all"
echo "See *-preparation.{out,err} for details"
echo
echo "You should now be able to run"
echo "    ./pytch-build/makesite/local-server/dev-server.sh"
echo "to launch a local development server"
echo
