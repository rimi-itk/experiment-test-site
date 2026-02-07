# shellcheck shell=bash

# https://github.com/bashly-framework/bashly/tree/master/examples/config#readme

echo "Customized values"
echo

for name in "${config_names[@]}"; do
    config_value=$(config_get "${name}")
    actual_value=$(config_get_value "${name}")

    if [ "${config_value}" == "${actual_value}" ]; then
        echo "  ${name} = ${actual_value}"
    fi
done

echo

echo "Default values"
echo

for name in "${config_names[@]}"; do
    config_value=$(config_get "${name}")
    actual_value=$(config_get_value "${name}")

    if [ "${config_value}" != "${actual_value}" ]; then
        echo "  ${name} = ${actual_value}"
    fi
done
