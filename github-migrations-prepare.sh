#!/bin/bash


# bash strict mode
set -euo pipefail
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

export OWNER=your-org
export REPO=${1:-}

# Prepare exports/migrations for given github repository.
# Migration information (ID/Repo-name) is stored in migrations.txt
# This textfile/database is used in the other migrations-related scripts
# This script required 'repo admin' permissions

if [ -z "$GH_TOKEN" ]; then
  echo "ERROR: Missing GH_TOKEN environment variable for GitHub. This needs the 'Full control of private repositories' checkbox."
  exit 1
fi

# Generate migration archive, append output to migrations.txt file
curl -q -s -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GH_TOKEN" \
    https://api.github.com/orgs/${OWNER}/migrations \
    --data-binary "{
 \"repositories\": [
   \"${OWNER}/${REPO}\"
 ],
 \"lock_repositories\": false
}" | tee -a migrations-full-data.txt | ( jq -j -c '.id," ",.repositories [] .name'; echo ) >> migrations.txt

# To later generate it again you need an extra newline: `cat migrations-full-data.txt | ( jq -j -c '.id," ",.repositories [] .name, "\n"'; echo ) > migrations.txt`
