# shellcheck shell=bash

enable_auto_colors

script_name=$(basename "${BASH_SOURCE[0]}")

# shellcheck disable=SC2034  # https://github.com/bashly-framework/bashly/blob/master/examples/config/src/lib/config.sh
CONFIG_FILE="${ITKDEV_TEST_SITE_CONFIG_FILE?:}"

# Global config variables
compose_command=$(config_get "compose_command" "itkdev-docker-compose-server")
compose_command_config_filename=$(config_get "compose_command_config_filename" ".env.docker.local")
compose_files=$(config_get "compose_files" "docker-compose.server.test.yml")
site_base_dir=$(config_get "site_base_dir" "${HOME}/.itkdev-test-site")

# Check if a base domain is set and is not currently being set.
if [[ -z "$(config_get "site_base_domain")" ]]; then
    if [[ ${command_line_args[0]} != "config" ]] || \
        [[ ${command_line_args[1]} != "set" ]] || \
        [[ ${command_line_args[2]} != "site_base_domain" ]]; then
        abort "Config value \"site_base_domain\" is not set." \
            "" "Run \`$script_name config set site_base_domain\` to set it, e.g." \
            "" "  $script_name config set site_base_domain test.example.com"
    fi
fi

site_base_domain=$(config_get "site_base_domain")
