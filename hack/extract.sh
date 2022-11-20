#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
#set -o xtrace

DATA_DIR=data

normalized_html=$(
  cat ${DATA_DIR}/dnsdumpster--twitter-com.html \
  | htmlq --pretty
)
host_records_only=$(
  echo -e "${normalized_html}" \
  | sed '1,/Host Records/d' \
  | sed '/Mapping the domain/,$d' \
)
cell_data=$(
  echo -e "${host_records_only}" \
  | htmlq -t .col-md-3 \
  | grep "\." \
  | tr -d ' ' \
)
ip_addrs=$(
  echo -e "${cell_data}" \
  | grep -v "[[:alpha:]]" \
  | sort --field-separator=. --numeric-sort \
)
host_names=$(
  echo -e "${cell_data}" \
  | grep "[[:alpha:]]" \
  | sort \
)

echo -e "${host_names}" >${DATA_DIR}/twitter-hostnames.txt
echo -e "${ip_addrs}" >${DATA_DIR}/twitter-ips.txt

