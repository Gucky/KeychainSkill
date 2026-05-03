#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  printf 'usage: %s SERVICE ACCOUNT\n' "$0" >&2
  exit 64
fi

service=$1
account=$2

if [[ -z "$service" ]]; then
  printf 'error=service_required\n' >&2
  exit 64
fi

if [[ -z "$account" ]]; then
  printf 'error=account_required\n' >&2
  exit 64
fi

set +e
output=$(security find-generic-password -s "$service" -a "$account" -w 2>&1)
rc=$?
set -e

printf 'rc=%d\n' "$rc"
if [[ $rc -eq 0 ]]; then
  printf 'found=yes\n'
  printf 'service=%s\n' "$service"
  printf 'account=%s\n' "$account"
  printf 'length=%d\n' "${#output}"
else
  printf 'found=unknown\n'
  printf 'service=%s\n' "$service"
  printf 'account=%s\n' "$account"
  printf 'error=%s\n' "$output"
fi

exit "$rc"
