site_id="${args[site-id]?:}"
yes="${args[--yes]:-}"

if [ ! "$yes" ]; then
    read -p "Really remove test site ${site_id} ([yN])? " -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
fi

site_dir="${site_base_dir?:}/${site_id}"
if [ ! -e "${site_dir}/${compose_command_config_filename?:}" ]; then
    abort "Site \"${site_id}\" does not look like a test site."
fi

print_info "Deleting test site \"${site_id}\""

site_delete "${site_dir}"

print_info "" "Test site deleted."
