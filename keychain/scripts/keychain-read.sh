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

set +e
output=$(security find-generic-password -s "$item_name" -w 2>&1)
rc=$?
set -e

printf 'rc=%d\n' "$rc"
if [[ $rc -eq 0 ]]; then
  printf 'found=yes\n'
  printf 'item=%s\n' "$item_name"
  printf 'length=%d\n' "${#output}"
else
  printf 'found=unknown\n'
  printf 'item=%s\n' "$item_name"
  printf 'error=%s\n' "$output"
fi

exit "$rc"
