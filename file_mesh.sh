#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#Get settings constants from the conf file 
source $DIR/file_mesh.conf

# TODO # Pre run checks, instance restriction, dependancy checks

cd ~/bin
#Locate Initialized Repos
repos=$(find $GIT_MNT -name '.git' -printf '%h\n')
echo "$repos"
#Clone all repos of GITHUB_USER
CWD=$PWD
cd $GIT_MNT # Chage to the Git repo directory
curl -s https://api.github.com/users/$GITHUB_USER/repos | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 git clone ||
echo "$repos" | xargs -n1 -i git pull {}
#Clone all gists

cd $CWD # Return to the previous directory
wait



#Automaticly push file changes within GIT_MNT
for i in $repos ; do
		(inotifywait -q -r -e CLOSE_WRITE --format="git commit -m 'autocommit on change' %w" $i | sh ) &
	echo "started Git atomic commits for $i"
done

#Archive repos on gdrive
# rclone mkdir "$RCLONE_MNT:Workspace/GitRepos"
# rclone sync $GIT_MNT "$RCLONE_MNT:Workspace/GitRepos" -vu --drive-use-trash --copy-links

#Locate USB Storage
# for i in $(find $USB_MNT )

#Archive to USB Storage