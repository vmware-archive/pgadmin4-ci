#!/usr/bin/env sh

set -e

tar -xf pgadmin-repo-tarball/*.tgz

metadata=$(cat pgadmin-repo/metadata.txt)
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
      "text":"$metadata",
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