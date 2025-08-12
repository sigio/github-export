#!/bin/bash

export OWNER=your-org
export REPO=${1:-}
export EXPORTDIR=./github-export/archives/$(date +%Y-%m)

if [ -z "$GH_TOKEN" ]; then
  echo "ERROR: Missing GH_TOKEN environment variable for GitHub. This needs the 'Full control of private repositories' checkbox."
  exit 1
fi

mkdir -p $EXPORTDIR

while UFS=" " read -r ID REPO
do
    echo -n "Getting migrations for id: $ID, "
    NEWURL=`curl -q -s -X GET \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Content-Type: application/json" \
        -H "Authorization: token $GH_TOKEN" \
        https://api.github.com/orgs/${OWNER}/migrations/$ID | jq -j -c '.archive_url'`
    echo "URL: $NEWURL, REPO: $REPO"

    if [ -n "$NEWURL" ];
    then
        # Download created archive, needs archive_url from above
        wget -O ${EXPORTDIR}/${REPO}.tgz `
            curl -X GET -H "Accept: application/vnd.github.v3+json" \
            -H "Authorization: token $GH_TOKEN" \
            https://api.github.com/orgs/${OWNER}/migrations/${ID}/archive`
    fi

done < "migrations.txt"
