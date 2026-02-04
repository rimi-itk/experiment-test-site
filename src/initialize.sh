# shellcheck shell=bash
# shellcheck disable=SC2034

enable_auto_colors

# shellcheck disable=SC2034  # https://github.com/bashly-framework/bashly/blob/master/examples/config/src/lib/config.sh
CONFIG_FILE="$ITKDEV_TEST_SITE_DEPLOY_CONFIG_FILE"

# Global variables
compose_command=$(config_get "compose_command" "itkdev-docker-compose-server")
compose_command_config_filename=$(config_get "compose_command_config_filename" ".env.docker.local")
compose_files=$(config_get "compose_files" "docker-compose.server.test.yml")

site_base_dir=$(config_get "site_base_dir" "${HOME}/itkdev/test-sites")

# if ! config_has_key "site_base_domain"; then
#     echo "Config value site_base_domain is not set."
#     echo
#     echo "Run \`itkdev-test-site-deploy config set site_base_domain\` to set it"
#     echo
#     exit 1
# fi

site_base_domain=$(config_get "site_base_domain")
