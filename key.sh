#!/bin/bash
echo "Getting the App Name =>"
APP_NAME=${PWD##*/}
echo $APP_NAME

echo "Creating a key.properties file =>"

read -p 'storePassword=' storePassword
read -p 'keyPassword=' keyPassword
echo -e 'storePassword='$storePassword'\nkeyPassword='$keyPassword'\nkeyAlias='$APP_NAME'\nstoreFile=cert/'$APP_NAME'.jks' > android/key.properties
