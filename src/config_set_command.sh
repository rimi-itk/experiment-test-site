# shellcheck shell=bash

# shellcheck disable=SC2154
name="${args[name]}"
value="${args[value]}"

config_set "$name" "$value"

echo "Config value $name set to $(config_get "$name")".
echo

echo "Current config:"
echo
itkdev_test_site_config_show_command
echo
