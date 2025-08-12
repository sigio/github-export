#!/bin/bash

export OWNER=your-org

# Fetch a list of archive-urls, from migrations listed in migrations.txt.
# Store output in 'export-urls.txt'
# These archives can be downloaded for upto ~10 days after creation

if [ -z "$GH_TOKEN" ]; then
  echo "ERROR: Missing GH_TOKEN environment variable for GitHub. This needs the 'Full control of private repositories' checkbox."
  exit 1
fi

while UFS=" " read -r ID REPO
do
    echo -n "Getting migrations for id: $ID, "
    NEWURL=`curl -q -s -X GET \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Content-Type: application/json" \
        -H "Authorization: token $GH_TOKEN" \
        https://api.github.com/orgs/${OWNER}/migrations/$ID | jq -j -c '.archive_url'`
    echo "URL: $NEWURL, REPO: $REPO"

#         -H "Authorization: token $GH_TOKEN" \

done < "migrations.txt"
