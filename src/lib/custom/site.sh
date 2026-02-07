# shellcheck shell=bash

site_get_dir() {
    site_id="$1"
    shift

    echo "${site_base_dir?:}/${site_id?:}"
}

site_get_url() {
    domain=$(grep COMPOSE_SERVER_DOMAIN "${compose_command_config_filename?:}")
    # https://tldp.org/LDP/abs/html/string-manipulation.html
    domain="${domain##*=}"

    if [ -z "${domain}" ]; then
        abort "Cannot get site URL"
    fi

    echo "https://${domain}"
}

site_get_created_at() {
    check_command "stat --format '%w' ." \
        "The \`stat\` command does not support the \`--format\` option." \
        "" "On macOS you can run" "" "  brew install coreutils" "" "to install GNU stat."

    stat --format '%W' "${compose_command_config_filename?:}"
}

site_delete() {
    site_dir="$1"
    shift

    run_command cd "${site_dir}"
    run_command "${compose_command?:}" down --remove-orphans --volumes
    run_command cd "$(dirname "${site_dir}")"
    run_command rm -fr "${site_dir}"
}
