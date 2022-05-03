#!/usr/bin/env bash
# Deploy script
notify-send 'Deploying My Autistic Self to the world!'
if branch=$(git symbolic-ref --short -q HEAD);then
  if [ "$branch" == "source" ]; then
    echo 'Getting latest changes...'
    git pull --rebase origin source
  else
    echo "Not on the source branch. We are on $branch so aborting!"
    exit 1
  fi
fi

if [[ $(git status --porcelain | wc -l) -gt 0 ]]; then
	echo 'Git status not clean, aborting deploy!'
	notify-send 'Git status not clean, aborting deploy!'
	exit 2
fi
echo 'Pushing changes to the source branch'
git push
datetime=$(date +'%Y-%m-%d %H:%M')
git gc --auto --prune
echo 'Building Jekyll...'
export JEKYLL_ENV=production
bundle exec jekyll build || exit 1
export JEKYLL_ENV=development
if [[ $(git status --porcelain | wc -l) -gt 0 ]]; then
  echo 'Git status not clean after build, aborting deploy!'
  notify-send 'Git status not clean after build, aborting deploy!'
  exit 3
fi
# echo 'Optimizing site....'
# LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "@{u}")
BASE=$(git merge-base @ "@{u}")
if [ "$REMOTE" = "$BASE" ]; then
    echo "Need to push changes to source!"
    git push
fi
echo 'Switching to main branch...'
git checkout main || exit 1
echo 'Copying build site to main branch'
# Also delete files no longer needed
rsync --delete --progress --checksum -z --archive _site/* . || exit 1
if [[ $(git status --porcelain | wc -l) -gt 0 ]]; then
  git add -A .
  git commit -m "Latest version of My Autistic Self - $datetime"
  echo 'Pushing latest to GitHub!'
  git gc --prune
  git push || exit 1
  git checkout source
  echo 'https://myautisticself.nl has been deployed.'
  notify-send 'https://myautisticself.nl has been deployed.'
  ./bin/generate-bitlys.rb
  git add db.json
  git commit -m "Added Bitly links after webpush - $datetime"
  git push
else
  notify-send 'Nothing was changed! Aborting deployment.'
  git checkout source
fi
