#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

commithash="`git rev-parse HEAD`"
commitlink="`git remote show origin -n | grep h.URL | sed 's/.*://;s/.git$//'`@$commithash"
hugoversion="`hugo version`"

# Move old files into trash.
echo -e "\033[0;32mMove old files into trash...\033[0m"
tmpdir="blog-post@$commithash"
mkdir "$tmpdir"
find ./public -maxdepth 1 -mindepth 1 -not -name ".git" -not -name ".gitignore" -print0 | xargs -0 mv -t "$tmpdir"
gio trash "$tmpdir"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="
Rebuilding site `date '+%Y-%m-%d %H:%M:%S'`

by $hugoversion
link to the commit: $commitlink
"

if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
while true; do
    read -p "Push? [y/n]" yn
    case $yn in
        [Yy]* ) git push origin master; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Come Back up to the Project Root
cd ..
