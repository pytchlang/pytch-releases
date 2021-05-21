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

# The pytch-tutorials submodule will be configured separately below.
for part in pytch-build pytch-vm pytch-webapp pytch-website; do
    (
        cd $part
        git checkout --quiet develop
    )
done

(
    echo "Preparing tutorials repo ..."

    cd pytch-tutorials

    # Ensure we have a local branch for every remote branch.

    for branchname in $(git for-each-ref --format='%(refname)' refs/remotes/origin/ \
                            | sed 's|^refs/remotes/origin/||'); do
        if [ "$branchname" != HEAD ]; then
            # Create branch if it doesn't already exist.
            git show-ref --quiet "refs/heads/$branchname" \
                || git branch --quiet "$branchname" "origin/$branchname"
        fi
    done

    echo "Prepared tutorials repo"
)

# Where possible, check each submodule out at the first named branch
# referring to its HEAD.
for m in $(git submodule foreach --quiet 'echo $name'); do
    (
        cd $m
        branch=$(git branch --no-column --format="%(refname:short)" --points-at $(git rev-parse HEAD) \
                     | grep -v "HEAD detached" \
                     | head -1)
        if [ ! -z "$branch" -a -z "$(git symbolic-ref --short -q HEAD)" ]; then
            git checkout --quiet "$branch"
        fi
    )
done

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
