# Check that we can use `date --date`, i.e. have GNU date (or campatible) at hand
# (https://www.gnu.org/software/coreutils/manual/html_node/Options-for-date.html)
check_command "date --date now" \
    "The \`date\` command does not support the \`--date\` option." \
    "" "On macOS you can run" "" "  brew install coreutils" "" "to install GNU date."

dry_run="${args[--dry-run]}"
created_before_spec=$(config_get "purge_created_before" "-1 week")
if [[ "${args[--created-before]}" ]]; then
    created_before_spec="${args[--created-before]}"
fi

# https://www.man7.org/linux/man-pages/man1/date.1.html
created_before=$(date --date "${created_before_spec}" +%s)

print_info "Purging sites created before $(format_datetime $created_before) ($(format_days_ago $created_before))."

if [ -e "${site_base_dir?:}" ]; then
    while IFS= read -r -d '' site_command_config_path; do
        site_dir=$(dirname "${site_command_config_path}")
        site_id="${site_dir##"${site_base_dir}/"}"
        site_created_at=$(cd "$site_dir" && site_get_created_at)
        if [ "$site_created_at" -lt "$created_before" ]; then
            if [ "$dry_run" ]; then
                print_info "Site \"${site_id}\" created at $(format_datetime $site_created_at) ($(format_days_ago $site_created_at)) will be purged"
            else
                print_info "Purging site \"${site_id}\" created at $(format_datetime $site_created_at) ($(format_days_ago $site_created_at))"
                site_delete "$site_dir"
            fi
        fi
    done < <(find "${site_base_dir?:}" -type f -name "${compose_command_config_filename?:}" -print0)
fi
