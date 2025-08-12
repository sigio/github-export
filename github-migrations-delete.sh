#!/bin/bash

export OWNER=your-org
export EXPORTDIR=./github-export/archives/$(date +%Y-%m)

# Read migrations.txt file for currently 'active' migrations.
# Check if files have been downloaded to $EXPORTDIR, and if so, remove the migration
# Will output a migrations.todo file with remaining migrations, manually rename this to
# migrations.txt for a new/next run

if [ -z "$GH_TOKEN" ]; then
  echo "ERROR: Missing GH_TOKEN environment variable for GitHub. This needs the 'Full control of private repositories' checkbox."
  exit 1
fi

while UFS=" " read -r ID REPO
do
    if [ -s ${EXPORTDIR}/${REPO}.tgz ];
    then
        # Archive has been downloaded, delete migration

        echo "Deleting migrations for id: $ID / Repo: $REPO"
        curl -q -s -X DELETE \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Content-Type: application/json" \
        -H "Authorization: token $GH_TOKEN" \
        https://api.github.com/orgs/${OWNER}/migrations/$ID/archive
    else
        echo "$ID $REPO" | tee -a migrations.todo
    fi
done < "migrations.txt"
