# shellcheck shell=bash

# inspect_args

# shellcheck disable=SC2154
show_compose_config="${args[--show-compose-config]}"
show_compose_containers="${args[--show-compose-containers]}"
verbose="${args[--verbose]}"

number_of_sites=0
if [ -e "${site_base_dir?:}" ]; then
    while IFS= read -r -d '' site_command_config_path; do
        ((++number_of_sites))
        site_dir=$(dirname "${site_command_config_path}")
        site_id="${site_dir##"${site_base_dir}/"}"
        echo "========================================================================================================================"
        echo "ID:         ${site_id}"

        created_at=""
        domain=""
        domain=$(grep COMPOSE_SERVER_DOMAIN "${site_command_config_path}")
        # https://tldp.org/LDP/abs/html/string-manipulation.html
        domain="${domain##*=}"
        # Note: `stat` in macOS (i.e. `/usr/bin/stat`) does not support `--format`
        if stat --format '%w' "${site_command_config_path}" > /dev/null 2>&1; then
            created_at=$(stat --format '%w' "${site_command_config_path}")
        fi

        echo "Repository: $(git -C "${site_dir}" remote get-url origin)"
        echo "Branch:     $(git -C "${site_dir}" rev-parse --abbrev-ref HEAD)"
        if [ -n "${created_at}" ]; then
            echo "Created at: ${created_at}"
        fi
        if [ -n "${domain}" ]; then
            echo "URL:        https://${domain}"
        fi

        if [ "${verbose}" ]; then
            echo "------------------------------------------------------------------------------------------------------------------------"
            cat <<EOF

Run

  ${script_name?:} remove ${site_id}

to remove this test site.
EOF
        fi
        if [ "${show_compose_config}" ]; then
            echo "------------------------------------------------------------------------------------------------------------------------"
            echo "${site_command_config_path}:"
            echo
            cat "${site_command_config_path}"
            echo
        fi
        if [ "${show_compose_containers}" ]; then
            echo "------------------------------------------------------------------------------------------------------------------------"
            (cd "${site_dir?:}" && "${compose_command?:}" ps --all)
        fi
        echo "========================================================================================================================"
        echo
    done < <(find "${site_base_dir?:}" -type f -name "${compose_command_config_filename?:}" -print0)
fi
if [ "${number_of_sites}" -eq 0 ]; then
    print_info "No test sites deployed."
fi
