#!/usr/bin/env bash

# The object here is to clone the isle-fedora repo, copy the contents of 
# transformations over it and patch the files that require patching.

echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'local' && export DB_ENDPOINT=$DB_ENDPOINT_LOCAL
echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'test' && export DB_ENDPOINT=$DB_ENDPOINT_TEST
echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'prod' && export DB_ENDPOINT=$DB_ENDPOINT_PROD

[[ $CODEBUILD_WEBHOOK_HEAD_REF ]] || DB_ENDPOINT=$DB_ENDPOINT_TEST
[[ $CLONE_BASE ]] || CLONE_BASE=./isle-fedora

OWD="${PWD}"
git clone https://github.com/Islandora-Collaboration-Group/isle-fedora.git "${CLONE_BASE}"
cp -r transformations/* "${CLONE_BASE}"
cd "${CLONE_BASE}"
patch < Dockerfile.patch
cd rootfs/etc/confd/conf.d
patch < fedora-filter-drupal.toml.patch
patch < sql.toml.patch
patch < fedora-fcfg.toml.patch
cd ../templates/fedora
patch < fedora.fcfg.tpl.patch
patch < filter-drupal.xml.tpl.patch
cd ../../../cont-init.d
patch < 01-fedora-config.patch
cd ../../utility_scripts
patch < rebuildFedora.sh.patch
cd "${OWD}/${CLONE_BASE}"
find . -type f -iname \*.patch -delete
cd "${OWD}"
exit 0
