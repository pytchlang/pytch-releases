#!/bin/bash

########################################################################
#
# Check required (versions of) tools are available

have_all_tools=yes
for tool in node git python3 realpath poetry; do
    if ! hash "$tool" 2> /dev/null; then
        echo Could not find "$tool"
        have_all_tools=no
    fi
done

if [ "$have_all_tools" = "no" ]; then
    echo
    echo "Required tool/s missing.  Please install it/them and try again."
    exit 1
fi

node_version=$(node --version)
if [ "$(echo "$node_version" | grep -c -E '^v14[.]')" -ne 1 ]; then
    echo Need node v14 but have "$node_version"
    exit 1
fi


########################################################################

cd_or_fail() { cd "$1" || exit 1; }

REPO_ROOT="$(dirname "$(realpath "$0")")"
cd_or_fail "$REPO_ROOT"

# Bail if it looks like we've already run.
if [ -e pytch-vm/src ] || [ -e pytch-webapp/src ]; then
    echo
    echo "It looks like development set-up has already been done"
    echo "Not making any changes"
    echo
    exit 1
fi

echo "Initialising submodules ..."

git submodule --quiet init
git submodule --quiet update

if [ ! -e pytch-vm/src ] || [ ! -e pytch-webapp/src ]; then
    echo
    echo "Failed to initialise submodules"
    echo
    exit 1
fi

(
    echo "  Preparing tutorials repo ..."

    (
        echo
        echo "# Following line added by develop.sh script of pytch-releases:"
        echo /site-layer/
    ) >> .git/modules/pytch-tutorials/info/exclude

    cd_or_fail pytch-tutorials

    # Ensure we have a local branch for every remote branch.

    for branchname in $(git for-each-ref --format='%(refname)' refs/remotes/origin/ \
                            | sed 's|^refs/remotes/origin/||'); do
        if [ "$branchname" != HEAD ]; then
            # Create branch if it doesn't already exist.
            git show-ref --quiet "refs/heads/$branchname" \
                || git branch --quiet "$branchname" "origin/$branchname"
        fi
    done

    echo "  Prepared tutorials repo"
)

# Where possible, check each submodule out at the first named branch
# referring to its HEAD.
#
# I do mean 'echo $name' in single quotes:
# shellcheck disable=SC2016
for m in $(git submodule foreach --quiet 'echo $name'); do
    (
        cd_or_fail "$m"
        branch=$(git branch --no-column --format="%(refname:short)" --points-at "$(git rev-parse HEAD)" \
                     | grep -v "HEAD detached" \
                     | head -1)
        if [ -n "$branch" ] && [ -z "$(git symbolic-ref --short -q HEAD)" ]; then
            git checkout --quiet "$branch"
        fi
    )
done

echo "Initialised submodules"

./pytch-build/makesite/pytch-git-status.sh

(
    echo "Preparing VM ..."

    cd_or_fail pytch-vm

    (
        npm install
        npm run devbuild
        ( cd_or_fail dist; ln -s skulpt.js skulpt.min.js )
    ) > "$REPO_ROOT"/pytch-vm-preparation.out 2> "$REPO_ROOT"/pytch-vm-preparation.err

    echo "Prepared VM"
) &

(
    echo "Preparing build tools ..."

    cd_or_fail pytch-build

    (
        # Poetry seems to want a keyring even if doing an operation which
        # doesn't need one.  Tell it to use a null one.
        PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
        export PYTHON_KEYRING_BACKEND

        poetry env use -q python3
        poetry install
    ) > "$REPO_ROOT"/pytch-build-preparation.out 2> "$REPO_ROOT"/pytch-build-preparation.err

    echo "Prepared build tools"
) &

(
    echo "Preparing webapp ..."

    cd_or_fail pytch-webapp

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
