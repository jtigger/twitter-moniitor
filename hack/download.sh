#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
# set -o xtrace

DATA_DIR=data
DATA_FILE=dnsdumpster--twitter-com.html

# - go to dnsdumpster.com
# - search for "twitter.com"
# - save as curl
# - add '-L'
raw_html=$(
curl -L 'https://dnsdumpster.com/' \
  -H 'authority: dnsdumpster.com' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'cookie: csrftoken=1ahcLQ2eg7xlCULZ80xrJ7oGAkDfte0e8OYZo8SK4s2ZVBL8nvEia3vX4G3DTfnr; _ga=GA1.2.228391834.1668908908; _gid=GA1.2.1132080648.1668908908; _gat=1' \
  -H 'origin: https://dnsdumpster.com' \
  -H 'referer: https://dnsdumpster.com/' \
  -H 'sec-ch-ua: "Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36' \
  --data-raw 'csrfmiddlewaretoken=UtcqbG3PZStuHmecP1n8tkJdQhYoJr2217TdOYTlNdY803el4wuZUgQukDoM9spf&targetip=twitter.com&user=free' \
  --compressed \
)

just_text=$( echo -e "${raw_html}" \ | htmlq --text )
if ! [[ "${just_text}" =~ "Showing results for twitter.com" ]]; then
  >&2 echo -e "Error: curl may have failed. (contents of ${DATA_DIR}/${DATA_FILE} are untouched)"
  exit 1
fi

echo -e "${raw_html}" > ${DATA_DIR}/${DATA_FILE}

