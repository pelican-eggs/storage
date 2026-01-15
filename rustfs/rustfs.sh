#!/bin/bash

##################################

echo "$(tput setaf 2)Starting up RustFS...."

echo "Startup Type: $(tput setaf 2)$STARTUP_TYPE"

if [ -f "keys/key.txt" ]; then

echo "$(tput setaf 2)Key file detected..."

export RUSTFS_ACCESS_KEY=`cat keys/key.txt`

else

echo rustfsadmin > keys/key.txt

echo "$(tput setaf 3)No key file detected...Preparing First Time Boot"

fi

if [ -f "keys/secret.txt" ]; then

echo "$(tput setaf 2)Secret file detected..."

export RUSTFS_SECRET_KEY=`cat keys/secret.txt`

else

echo rustfsadmin > keys/secret.txt

echo "No secret file detected...Preparing First Time Boot"

fi

if [ -f "keys/oldsecret.txt" ]; then

echo "$(tput setaf 1)Old secret file detected..."

export RUSTFS_SECRET_KEY_OLD=`cat keys/oldsecret.txt`

fi

if [ -f "keys/oldkey.txt" ]; then

echo "$(tput setaf 1)Old key file detected..."

export RUSTFS_ACCESS_KEY_OLD=`cat keys/oldkey.txt`

fi

if [ -f "keys/justrotated.txt" ]; then

echo "$(tput setaf 3)Previous key rotation detected...."

echo "$(tput setaf 3)Clearing the Lanes...."

unset RUSTFS_ACCESS_KEY_OLD

unset RUSTFS_SECRET_KEY_OLD

echo "$(tput setaf 2)Lanes Cleared!"

STARTUP_TYPE=normal

rm keys/justrotated.txt

rm keys/oldsecret.txt

rm keys/oldkey.txt

fi

##########################################

if [ -z "$STARTUP_TYPE" ] || [ "$STARTUP_TYPE" == "update" ]; then

echo "$(tput setaf 3)Performing update...."

echo "$(tput setaf 1)Removing old rustfs version"

rm rustfs

echo "$(tput setaf 3)Downloading new rustfs version"

wget https://github.com/rustfs/rustfs/releases/download/1.0.0-alpha.79/rustfs-linux-x86_64-musl-latest.zip

unzip -o rustfs-linux-x86_64-musl-latest.zip

chmod +x rustfs

rm rustfs-linux-x86_64-musl-latest.zip

echo "$(tput setaf 2)Update Complete"

fi

##########################################

if [ -z "$STARTUP_TYPE" ] || [ "$STARTUP_TYPE" == "rotate" ]; then

touch keys/justrotated.txt

export RUSTFS_ACCESS_KEY_OLD=$RUSTFS_ACCESS_KEY

echo $RUSTFS_ACCESS_KEY_OLD > keys/oldkey.txt

export RUSTFS_SECRET_KEY_OLD=$RUSTFS_SECRET_KEY

echo $RUSTFS_SECRET_KEY_OLD > keys/oldsecret.txt

export RUSTFS_ACCESS_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo $RUSTFS_ACCESS_KEY > keys/key.txt

export RUSTFS_SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo $RUSTFS_SECRET_KEY > keys/secret.txt

echo "Your New Access Key is: $(tput setaf 2)$RUSTFS_ACCESS_KEY"

echo "Your New Secret Key is: $(tput setaf 2)$RUSTFS_SECRET_KEY"

echo "Your Old Access Key is: $(tput setaf 3)$RUSTFS_ACCESS_KEY_OLD"

echo "Your Old Secret Key is: $(tput setaf 3)$RUSTFS_SECRET_KEY_OLD"

echo "$(tput setaf 2)Booting..."

export RUSTFS_VOLUMES=$DATA_LOCATION

export RUSTFS_ADDRESS=":$SERVER_PORT"

export RUSTFS_CONSOLE_ENABLE=false
if [ "$ENABLE_CONSOLE" = "1" ]; then
    export RUSTFS_CONSOLE_ADDRESS=":$CONSOLE_PORT"
    export RUSTFS_CONSOLE_ENABLE=true
fi

export RUST_LOG=error

./rustfs $DATA_LOCATION

else

echo "$(tput setaf 2)Booting..."

export RUSTFS_VOLUMES=$DATA_LOCATION

export RUSTFS_ADDRESS=":$SERVER_PORT"

export RUSTFS_CONSOLE_ENABLE="$CONSOLE_PORT"

export RUSTFS_CONSOLE_ENABLE=false
if [ "$ENABLE_CONSOLE" = "1" ]; then
    export RUSTFS_CONSOLE_ADDRESS=":$CONSOLE_PORT"
    export RUSTFS_CONSOLE_ENABLE=true
fi

export RUST_LOG=error

./rustfs $DATA_LOCATION

fi

