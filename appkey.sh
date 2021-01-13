#!/bin/bash 

echo "Getting the Project Path =>"
PATH_PROJECT=$(pwd)
echo $PATH_PROJECT

echo "Getting the App Name =>"
APP_NAME=${PWD##*/}
echo $APP_NAME

echo "Creating 'cert' Directory at 'android/app' =>"
mkdir android/app/cert
echo 'Directory Created Successfully'

echo "Creating a .jks key & storing at 'android/app/cert/' directory =>"
keytool -genkey -v -keystore android/app/cert/$APP_NAME.jks -keyalg RSA -keysize 2048 -validity 20000 -alias $APP_NAME

echo "Updating the .jks key to PKCS12 =>"
keytool -importkeystore -srckeystore android/app/cert/$APP_NAME.jks -destkeystore android/app/cert/$APP_NAME.jks -deststoretype pkcs12

echo "Creating directory at 'KEYS' =>"
mkdir ../KEYS/$APP_NAME

echo "Copying 'cert' directory at 'KEYS' =>"
cp -r android/app/cert/ ../KEYS/$APP_NAME/

