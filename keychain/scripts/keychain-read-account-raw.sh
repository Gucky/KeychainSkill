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

security find-generic-password -s "$service" -a "$account" -w
