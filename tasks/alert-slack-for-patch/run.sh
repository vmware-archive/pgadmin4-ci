#!/usr/bin/env sh

set -e

title_link=$(cat build-metadata/build-url)
body=$(cat patches/body)
text="*$(cat patches/from) - $(cat patches/subject)*\n$(echo ${body} | cut -c 1-150)...\n$(cd patches/attachments && ls )"
payload=$(cat <<EOF
{
"username": "patches-bot",
"icon_emoji": ":robot_face:",
"attachments": [
   {
      "fallback":"${TITLE} - ${title_link}",
      "pretext":" ",
      "title":"${TITLE}",
      "title_link":"${title_link}",
      "text":"${text}",
      "color":"${COLOR}"
   }
 ]
}
EOF
)

for url in ${SLACK_URLS}; do
    curl \
      -X POST \
      --data-urlencode "payload=${payload}" \
      ${url}
done
