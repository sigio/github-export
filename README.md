# Export your github repos

## Credentials

- Export credentials:
This needs a token with all the checkboxes on 'repo' and  'admin:org'
```
export GH_TOKEN=YOUR_TOKEN
```

## Preparing the exports

- `rm -v repos.list migrations.txt`
- Update the list of existing (unarchived) repos:
  - `./github-list-repos.sh > repos.list`
- Prepare github migrations for all repos: (This creates migrations.txt)

```
   for repo in `cat repos.list`
   do
     ./github-migrations-prepare.sh $repo
   done
```

## Download the exports

- Now wait for the migrations to be created by github. For large repos this
  can take a couple of hours.
- Get the download-urls, using data in migrations, output in export-urls.txt
  - `./github-migrations-fetch-urls.sh | tee export-urls.txt`
  - check for null values, `grep null export-urls.txt`
- If export-urls.txt has as many lines as migrations.txt `wc -l migrations.txt export-urls.txt`, and no 'null' records, they should all be prepared at the github side, so can be downloaded:
  - `./github-migrations-download.sh`
- Then remove the migration-jobs after downloading, so you don't keep paying for this extra storage:
  - `./github-migrations-delete.sh`


