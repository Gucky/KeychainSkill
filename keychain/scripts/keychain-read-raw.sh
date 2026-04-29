#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf 'usage: %s ITEM_NAME\n' "$0" >&2
  exit 64
fi

item_name=$1

if [[ -z "$item_name" ]]; then
  printf 'error=item_name_required\n' >&2
  exit 64
fi

security find-generic-password -s "$item_name" -w
