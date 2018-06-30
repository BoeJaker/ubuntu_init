
#This file Describes and installs all dependencies

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get settings constants from the conf file 
source $DIR/file_mesh.conf

sudo apt-get install git curl  

git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600' # Set the cache to timeout after 1 hour (setting is in seconds)

#Rclone + config
if [ "$(apt list 2>/dev/null | grep '^rclone/' &>/dev/null)" ] ; then

	curl https://rclone.org/install.sh | sudo bash &
	wait
	rclone config

fi