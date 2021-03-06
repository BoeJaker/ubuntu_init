#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get settings constants from the conf file 
source $DIR/file_mesh.conf
exec $DIR/file_mesh_dependancies.sh &
# Locate Initialized Repos
repos=$(find $GIT_MNT -name '.git' -printf '%h\n')

CWD=$PWD # Save the current working directory
for i in $repos ; do
	cd $i
	find ./ -maxdepth 1 -mindepth 0 -name "key" &>/dev/null ||
	ssh-keygen -t rsa -b 4096 -f ./key -C "j.baker.cwp@gmail.com"
done
cd $CWD # Return to the previous directory

# Atomic automatic push file changes within GIT_MNT
# TODO # Add GUI to input commit message
for i in $repos ; do
		(inotifywait -mr -e CLOSE_WRITE --format="CWD=$PWD ; cd %w ; git commit -m 'atomic on change' %w%f && rm ./.git/index.lock ; cd $PWD ;" $i 2>/dev/null )  &
done

# TODO # Pre run checks, instance restriction, dependancy checks
(
	while true ; do
		# Check for new repos and clone all of GITHUB_USER
		CWD=$PWD # Save the current working directory
		cd $GIT_MNT # Chage to the Git repo directory
		curl -s https://api.github.com/users/$GITHUB_USER/repos | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 -i git clone {} 2>/dev/null 
		# Clone all gists
		cd $CWD # Return to the previous directory
		wait

		# Locate Initialized Repos
		repos=$(find $GIT_MNT -name '.git' -printf '%h\n')

		# Pull Repo Updates
		for i in $repos ; do
			cd "$i" ; git pull origin master
		done
		wait 
		sleep $((60*10)) # Update every 10 minutes
	done
) &


# Archive repos on gdrive
# rclone mkdir "$RCLONE_MNT:Workspace/GitRepos"
# rclone sync "$GIT_MNT" "$RCLONE_MNT:Workspace/GitRepos" -vu --drive-use-trash --copy-links &
#rclone mkdir "$RCLONE_MNT:Workspace/bin"
#rclone sync $BIN gdrivejbaker:Workspace/bin -vu --drive-use-trash --copy-links

# Locate USB Storage
# for i in $(find $USB_MNT )

# Archive to USB Storage

# Locate local FTP/SSH servers:

# Archive to FTP/SSH