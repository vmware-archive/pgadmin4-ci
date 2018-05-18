#!/usr/bin/env sh

set -e

tar -xf pgadmin-repo-tarball/*.tgz
title_link=$(cat build-metadata/build-url)
metadata=$(cat pgadmin-repo/metadata.txt | sed 's,",\\",g')
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
      "text":"${metadata}",
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
