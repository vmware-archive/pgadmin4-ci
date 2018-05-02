#!/usr/bin/env sh

set -e

text="*$(cat patches/subject)*\n$(cd patches/attachments && ls )"
title_link=$(cat build-metadata/build-url)
payload=$(cat <<EOF
{
"channel": "#pgadmin4",
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

curl \
  -X POST \
  --data-urlencode "payload=$payload" \
  $SLACK_URL