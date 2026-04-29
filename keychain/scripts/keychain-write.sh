#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  printf 'usage: %s ITEM_NAME VALUE\n' "$0" >&2
  exit 64
fi

item_name=$1
value=$2
account=${USER:-$(id -un)}

if [[ -z "$item_name" ]]; then
  printf 'error=item_name_required\n' >&2
  exit 64
fi

security add-generic-password -s "$item_name" -a "$account" -w "$value" -U >/dev/null

printf 'stored=yes\n'
printf 'item=%s\n' "$item_name"
printf 'value_length=%d\n' "${#value}"
