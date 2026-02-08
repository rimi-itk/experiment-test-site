# shellcheck shell=bash

print_info() {
    for message in "$@"; do
        echo "$message"
    done
}

print_error() {
    width=120

    rule=$(printf '=%.0s' $(seq 1 "$width"))
    echo "$rule"
    for message in "$@"; do
        message="$(echo "$message" | fold -w "$width" -s)"
        echo "$message"
    done
    echo "$rule"
}

abort() {
    print_error "${@}" >&2
    exit 1
}

format_datetime() {
    timestamp="$1"
    shift
    format=${1:-seconds}

    date --date "@${timestamp}" --iso-8601="$format"
}

format_date() {
    format_datetime "$@" date
}

# https://linuxvox.com/blog/bash-relative-date-x-days-ago/
format_days_ago() {
    timestamp="$1"
    shift

    days_ago=$(( ( $(date +%s) - $(date -d "@$timestamp" +%s) ) / 86400 ))

    if [ "$days_ago" -lt -1 ]; then
        echo "in $(( -days_ago )) days"
    elif [ "$days_ago" -lt 0 ]; then
        echo "in 1 day"
    elif [ "$days_ago" -gt 1 ]; then
        echo "${days_ago} days ago"
    else
        echo "1 day ago"
    fi
}
