# shellcheck shell=bash

export config_names=(
    compose_command
    compose_command_config_filename
    compose_files
    site_base_dir
    site_base_domain
)

config_get_value() {
    name="$1"
    shift

    default=""

    # Validate config naem and set default value
    case "${name}" in
        compose_command)
            default="itkdev-docker-compose-server"
            ;;
        compose_command_config_filename)
            default=".env.docker.local"
            ;;
        compose_files)
            default="docker-compose.server.test.yml"
            ;;
        site_base_dir)
            default="${HOME}/itkdev/test-sites"
            ;;
        site_base_domain)
            ;;
        *)
            abort "Invalid config name: ${name}"
            ;;
    esac

    if [ "${#}" -gt 0 ]; then
    default="$1"
    shift
    fi

    # https://github.com/bashly-framework/bashly/tree/master/examples/config#readme
    config_get "${name}" "${default}"
}
