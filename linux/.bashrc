## Variables
# Define your variables here
 
# --- Loader *Start* --- #
mkdir -p ~/._bash

function src () {
  if [ -s $1 ]
  then
      source $filename
  fi
}

function load () {
    hash=$(shasum <<< $1 | head -c 40)
    filename=$(echo "$HOME/._bash/$hash")


    if [ -s $filename ]
    then
        src $filename
        # Save latest changes for next run
        curl -f -s -o $filename $1 &
    else
        curl -f -s -o $filename $1
        src $filename
    fi

}
# --- Loader *End* -- #

## Load Modules
# load "https://raw.githubusercontent.com/reezpatel/awesome-dev/master/linux/alias.sh"
