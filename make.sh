#!/bin/bash

cd_or_fail() { cd "$1" || exit 1; }

REPO_ROOT="$(dirname "$(realpath "$0")")"
cd_or_fail "$REPO_ROOT"

# Rough test that submodules have been init'd correctly:
if [ ! -x pytch-vm/website-layer/make.sh ]; then
    (
        echo "It looks like submodules have not been set up yet.  If you"
        echo "have just cloned this repo, you can run 'develop.sh' to set"
        echo "up the submodules and branches."
    ) >&2
    exit 1
fi

if [ "$(git status --ignore-submodules=none --porcelain | wc -l)" -ne 0 ]; then
    (
        echo "Working directory not clean; abandoning build"
        echo
        git status
    ) >&2
    exit 1
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$current_branch" = releases ]; then
    current_tag="$(git tag --points-at)"
    if [ -z "$current_tag" ]; then
        >&2 echo No tag found pointing to HEAD on releases
        exit 1
    fi

    current_tutorials_branch="$(cd pytch-tutorials && git rev-parse --abbrev-ref HEAD)"
    if [ "$current_tutorials_branch" != releases ]; then
        >&2 echo Top level repo is on '"releases"' branch but tutorials is not
        exit 1
    fi

    bare_version=$(echo $current_tag | sed 's/^v//')
    zipfile_name=release-"$bare_version".zip
    containing_dir=releases/"$bare_version"
    export DEPLOY_BASE_URL=/
    export PYTCH_VERSION_TAG=$current_tag
else
    if [ ! -e pytch-tutorials/index.yaml ]; then
        >&2 echo "No pytch-tutorials/index.yaml found; is correct branch checked out?"
        exit 1
    fi

    bare_version=""
    head_sha="$(git rev-parse HEAD | cut -c -12)"
    zipfile_name=beta-g${head_sha}.zip

    if [ -n "$PYTCH_DEPLOY_BASE_URL" ]; then
        containing_dir="${PYTCH_DEPLOY_BASE_URL#/}"
        if [ "$PYTCH_DEPLOY_BASE_URL" = "$containing_dir" ]; then
            >&2 echo "PYTCH_DEPLOY_BASE_URL must start with a '/' character"
            exit 1
        fi
        >&2 echo "Using custom DEPLOY_BASE_URL $PYTCH_DEPLOY_BASE_URL"
    else
        containing_dir=beta/g${head_sha}
    fi

    export DEPLOY_BASE_URL=/${containing_dir}
    export PYTCH_VERSION_TAG=g$head_sha
fi

export PYTCH_DEPLOYMENT_ID=$(git rev-parse HEAD | cut -c -20)

>&2 echo Making "$zipfile_name"

logdir_relative="build-logs/$(date +%Y%m%dT%H%M%S)"
LOGDIR="$REPO_ROOT/$logdir_relative"
mkdir -p "$LOGDIR"

>&2 echo Logging to "$logdir_relative"

toplevel_htaccess() {
    sed "s/VERSION-STRING/$bare_version/" < "$REPO_ROOT"/toplevel-htaccess-template
}

git submodule --quiet update \
    && (
        rm -rf pytch-vm/node_modules \
           pytch-vm/website-layer/layer-content \
           pytch-vm/website-layer/layer.zip
        rm -rf pytch-webapp/node_modules \
           pytch-webapp/website-layer/layer-content \
           pytch-webapp/website-layer/layer.zip
        rm -rf pytch-website/venv \
           pytch-website/website-layer/layer-content \
           pytch-website/website-layer/layer.zip
        rm -rf pytch-build/venv \
           pytch-build/website-layer/layer-content \
           pytch-build/website-layer/layer.zip
    ) \
    && (
        (
            cd pytch-vm
            website-layer/make.sh > "$LOGDIR"/pytch-vm.out 2> "$LOGDIR"/pytch-vm.err
            >&2 echo Built pytch-vm layer
        ) &

        (
            cd pytch-webapp
            website-layer/make.sh > "$LOGDIR"/pytch-webapp.out 2> "$LOGDIR"/pytch-webapp.err
            >&2 echo Built pytch-webapp layer
        ) &

        (
            cd pytch-website
            website-layer/make.sh > "$LOGDIR"/pytch-website.out 2> "$LOGDIR"/pytch-website.err
            >&2 echo Built pytch-website layer
        ) &

        (
            # This builds the tutorials layer, hence break in pattern for out/err files.
            cd pytch-build
            makesite/tutorials-layer.sh > "$LOGDIR"/pytch-tutorials.out 2> "$LOGDIR"/pytch-tutorials.err
            >&2 echo Built pytch-tutorials layer
        ) &

        wait
    ) \
    && (
        mkdir -p website-layer
        cd_or_fail website-layer
        rm -rf "$containing_dir"
        mkdir -p "$containing_dir"

        # The tutorials come from 'pytch-build'.
        for repo in pytch-vm pytch-webapp pytch-website pytch-build; do
            unzip -q -d "$containing_dir" ../"$repo"/website-layer/layer.zip
        done

        if [ -n "$bare_version" ]; then
            >&2 echo Writing htaccess to redirect "$bare_version"
            toplevel_htaccess "$bare_version" > "$containing_dir"/toplevel-dot-htaccess
        fi

        rm -f "$zipfile_name"
        zip -q -r "$zipfile_name" "$containing_dir"

        tarfile_name="${zipfile_name%.zip}".tar.gz
        tar zcf "$tarfile_name" "$containing_dir"
    )

echo "$(pwd)"/website-layer/"$zipfile_name"
