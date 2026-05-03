#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  printf 'usage: %s SERVICE ACCOUNT VALUE\n' "$0" >&2
  exit 64
fi

service=$1
account=$2
value=$3

if [[ -z "$service" ]]; then
  printf 'error=service_required\n' >&2
  exit 64
fi

if [[ -z "$account" ]]; then
  printf 'error=account_required\n' >&2
  exit 64
fi

security add-generic-password -s "$service" -a "$account" -w "$value" -U >/dev/null

printf 'stored=yes\n'
printf 'service=%s\n' "$service"
printf 'account=%s\n' "$account"
printf 'value_length=%d\n' "${#value}"
