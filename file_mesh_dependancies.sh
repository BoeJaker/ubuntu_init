
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get settings constants from the conf file 
source $DIR/file_mesh.conf

#This file Describes and installs all dependencies
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"

#Rclone + config
curl https://rclone.org/install.sh | sudo bash &
wait
rclone config