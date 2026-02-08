# shellcheck shell=bash

# shellcheck disable=SC2154
name="${args[name]}"
value="${args[value]}"

# https://linuxsimply.com/bash-scripting-tutorial/string/manipulation/trim-string/
value="${value#"${value%%[![:space:]]*}"}"
value="${value%"${value##*[![:space:]]}"}"

if [ -z "${value}" ]; then
    abort "Config value for \"${name}\" cannot be blank"
fi

config_set "$name" "$value"

echo "Config value \"$name\" set to \"$(config_get "$name")\"."
echo

echo "Current config:"
echo
itkdev_test_site_config_show_command
echo
