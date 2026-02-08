# shellcheck shell=bash

name="${args[name]}"

config_del "${name}"

echo "Config value \"$name\" unset."
echo

echo "Current config:"
echo
itkdev_test_site_config_show_command
echo
