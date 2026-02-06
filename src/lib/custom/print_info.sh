# shellcheck shell=bash

print_info() {
    for message in "$@"; do
        yellow "$message"
    done
}

print_error() {
    width=120
    message="$(echo "$*" | fold -w $width -s)"

    red "$(printf '=%.0s' $(seq 1 $width))"
    red "$message"
    red "$(printf '=%.0s' $(seq 1 $width))"
}

run_command() {
    # shellcheck disable=SC2154
    debug="${args[--debug]}"

    if [[ $debug ]]; then
        echo ""
        echo "> $*"
        # https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
        # set -x

        # https://docs.docker.com/compose/how-tos/environment-variables/envvars/#compose_progress
        COMPOSE_PROGRESS=auto "$@"

        # set +x
    else
        command="$1"
        if [ "$command" = "task" ]; then
            # https://taskfile.dev/docs/reference/cli#s-silent
            set -- "$command" --silent "${@:2}"
        fi

        COMPOSE_PROGRESS=quiet "$@" > /dev/null
    fi
}
