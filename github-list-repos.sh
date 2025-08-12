#!/bin/bash

OWNER=your-org

# List active (unarchived) github repos for the organisation

if [ -z "$GH_TOKEN" ]; then
  echo "ERROR: Missing GH_TOKEN environment variable for GitHub. This needs the 'Full control of private repositories' checkbox."
  exit 1
fi

# List alle github repos, filter out archived

gh api --method GET \
    -H "Accept: application/vnd.github.v3+json" \
    /orgs/${OWNER}/repos \
    -f type=all --paginate \
    | jq -r '. [] | select( .archived == false) | .name'
