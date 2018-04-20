#!/usr/bin/env bash

set -e

tar -xf pgadmin-repo-tarball/*.tgz

metadata=$(< pgadmin-repo/metadata.txt)

payload=$(cat <<EOF
{
"channel": "#pgadmin4",
"username": "patches-bot",
"icon_emoji": ":robot_face:",
"attachments":[
   {
      "fallback":"$TITLE_MESSAGE (<https://gpdb-dev.bosh.pivotalci.info/teams/pgadmin/pipelines/pgadmin-patch/jobs/run-tests|build>)",
      "pretext":"$TITLE_MESSAGE (<https://gpdb-dev.bosh.pivotalci.info/teams/pgadmin/pipelines/pgadmin-patch/jobs/run-tests|build>)",
      "color":"$TINT_COLOR",
      "fields":[
         {
            "title":"Info",
            "value":"$metadata",
            "short":false
         }
      ]
   }
]
}
EOF
)

curl \
  -X POST \
  --data-urlencode "payload=$payload" \
  $SLACK_URL