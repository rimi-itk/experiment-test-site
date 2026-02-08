# shellcheck shell=bash

check_command() {
    command="$1"
    shift

    if ! eval "${command}" > /dev/null 2>&1; then
        abort "$@"
    fi
}

run_command() {
    # shellcheck disable=SC2154
    verbose="${args[--verbose]}"
    debug="${args[--debug]}"
    if [[ $debug ]]; then
        verbose=1
    fi

    if [[ $verbose ]]; then
        echo "> $*"
    fi

    if [[ $debug ]]; then
        # https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
        # set -x

        # https://docs.docker.com/compose/how-tos/environment-variables/envvars/#compose_progress
        COMPOSE_PROGRESS=auto "$@"

        # set +x
    else
        # command="$1"
        # if [ "$command" = "task" ]; then
        #     # https://taskfile.dev/docs/reference/cli#s-silent
        #     set -- "$command" --silent "${@:2}"
        # fi

        # @todo Catch stderr output and print it if command fails.
        COMPOSE_PROGRESS=quiet "$@" &> /dev/null
    fi
}
