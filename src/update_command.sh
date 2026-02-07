site_id="${args[site-id]?:}"
install_site="${args[--install]:-}"

site_dir=$(site_get_dir "${site_id}")
if [ ! -e "${site_dir}" ]; then
    abort "\"${site_id}\" is not a valid site ID"
fi
if [ ! -e "${site_dir}/${compose_command_config_filename?:}" ]; then
    abort "Cannot find compose config file for site \"${site_id}\""
fi

cd "${site_dir}" || exit

site_url=$(site_get_url)

branch=$(git rev-parse --abbrev-ref HEAD)

run_command git fetch
run_command git reset --hard "origin/${branch}"
run_command git log -3

if [ "${install_site}" ]; then
    print_info "Reinstalling test site \"${site_id}\""
    run_command task test-site:install
    print_info "" "Test site installed and available on" "" "  ${site_url}" ""
else
    print_info "Updating test site \"${site_id}\""
    run_command task test-site:update
    print_info "" "Test site updated and available on" "" "  ${site_url}" ""
fi
