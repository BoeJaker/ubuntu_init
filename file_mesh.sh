#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get settings constants from the conf file 
source $DIR/file_mesh.conf

# TODO # Pre run checks, instance restriction, dependancy checks

# Check for new repos and clone all of GITHUB_USER
CWD=$PWD
cd $GIT_MNT # Chage to the Git repo directory
curl -s https://api.github.com/users/$GITHUB_USER/repos | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 -i git clone {} 2>/dev/null 
# Clone all gists
cd $CWD # Return to the previous directory
wait

# Locate Initialized Repos
repos=$(find $GIT_MNT -name '.git' -printf '%h\n')
echo "$repos"

# Fetch Updates
for i in $repos ; do
	cd "$i" ; git pull origin master
done
wait

# Atomic automatic push file changes within GIT_MNT
for i in $repos ; do
		(inotifywait -mr -e CLOSE_WRITE --format="CWD=$PWD ; cd %w ; git commit -m 'autocommit on change' %w%f && rm ./.git/index.lock ; cd $PWD ;" $i 2>/dev/null &&  echo "started Git atomic commits for $i" )  &
done

#
# Archive repos on gdrive
# rclone mkdir "$RCLONE_MNT:Workspace/GitRepos"
# rclone sync $GIT_MNT gdrivejbaker:Workspace/GitRepos -vu --drive-use-trash --copy-links
#rclone mkdir "$RCLONE_MNT:Workspace/bin"
#rclone sync $GIT_MNT gdrivejbaker:Workspace/bin -vu --drive-use-trash --copy-links
#
#

# Locate USB Storage
# for i in $(find $USB_MNT )

# Archive to USB Storage

# Locate local FTP/SSH servers:

# Archive to FTP/SSH