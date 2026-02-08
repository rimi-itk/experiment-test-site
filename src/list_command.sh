# shellcheck shell=bash

show_compose_config="${args[--show-compose-config]}"
show_compose_containers="${args[--show-compose-containers]}"
verbose="${args[--verbose]}"
quiet="${args[--quiet]}"

number_of_sites=0
if [ -e "${site_base_dir?:}" ]; then
    while IFS= read -r -d '' site_command_config_path; do
        ((++number_of_sites))
        site_dir=$(dirname "${site_command_config_path}")
        site_id="${site_dir##"${site_base_dir}/"}"
        if [ "${quiet}" ]; then
            echo "${site_id}"
            continue
        fi
        cd "${site_dir}" || exit
        site_created_at=$(site_get_created_at)
        site_url=$(site_get_url)

        echo "========================================================================================================================"
        echo "ID:         ${site_id}"

        echo "Repository: $(git -C "${site_dir}" remote get-url origin)"
        echo "Branch:     $(git -C "${site_dir}" rev-parse --abbrev-ref HEAD)"
        if [ -n "${site_created_at}" ]; then
            echo "Created at: $(format_datetime "${site_created_at}") ($(format_days_ago $site_created_at))"
        fi
        if [ -n "${site_url}" ]; then
            echo "URL:        ${site_url}"
        fi

        if [ "${verbose}" ]; then
            echo "------------------------------------------------------------------------------------------------------------------------"
            cat <<EOF

Update test site by running

  ${script_name?:} update ${site_id}

Delete it by running

  ${script_name?:} delete ${site_id}

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

if [ ! "${quiet}" ]; then
    if [ "${number_of_sites}" -eq 0 ]; then
        print_info "No sites installed."
    fi
fi
