#!/usr/bin/env sh

set -e

text="*$(cat patches/subject)*\n$(ls patches/attachments/* |  xargs basename )"
payload=$(cat <<EOF
{
"channel": "#pgadmin4",
"username": "patches-bot",
"icon_emoji": ":robot_face:",
"attachments": [
   {
      "fallback":"$TITLE - $TITLE_LINK",
      "pretext":" ",
      "title":"$TITLE",
      "title_link":"$TITLE_LINK",
      "text":"$text",
      "color":"$COLOR"
   }
 ]
}
EOF
)

curl \
  -X POST \
  --data-urlencode "payload=$payload" \
  $SLACK_URL