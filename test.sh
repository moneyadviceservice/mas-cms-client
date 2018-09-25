#!/bin/bash -l

if [ -f /.dockerenv ]; then
    source ~/.bashrc
    rvm use default
    bundle config github.com $GITHUB_USER:$GITHUB_PASS
fi

export RAILS_ENV=test
export BUNDLE_WITHOUT=development:build

exit_code=0

function run {
    declare -a tests_command=("$@")
    echo ''
    echo "=== Running \`${tests_command[*]}\`"
    if ! ${tests_command[*]}; then
        echo "=== These tests failed."
        exit_code=1
    fi
}

function info {
    declare -a info_command=("$@")
    echo ''
    echo "=== Running for informational purposes \`${info_command[*]}\`"
    if ! ${info_command[*]}; then
        echo "== This test has errors and/or warnings. Please review results"
    fi
}

run ./bin/setup
run bundle exec rubocop .
run bundle exec rspec

if [ -f /.dockerenv ]; then
  run bundle exec danger --verbose
fi

exit "$exit_code"
