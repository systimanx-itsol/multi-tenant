#!/bin/bash

# e causes to exit when one commands returns non-zero
# v prints every line before executing
set -ev

cd ${TRAVIS_BUILD_DIR}/laravel

echo "requiring composer package ${TRAVIS_REPO_SLUG} ${TRAVIS_BRANCH}"

if [[ ${TRAVIS_BRANCH} =~ "^(([0-9]+\.)+[0-9]+)$" ]]; then
    travis_retry composer require ${TRAVIS_REPO_SLUG}:${TRAVIS_BRANCH}
else
    # development package of framework could be required for the package
    travis_retry composer require hyn-me/framework "dev-master as 0.1.99"
    travis_retry composer require ${TRAVIS_REPO_SLUG}:dev-${TRAVIS_BRANCH}
fi

# moves the unit test to the root laravel directory
cp ./vendor/hyn-me/multi-tenant/phpunit.travis.xml ./phpunit.xml

phpunit