#!/bin/bash

# our conan instance
remotes="$(conan remote list)"
amazon_remote="http://ec2-52-28-60-213.eu-central-1.compute.amazonaws.com:9300/"
if [[ $remotes == *"amazon: $amazon_remote"* ]]; then
    echo "amazon already in conan remotes"
else
    conan remote add amazon $amazon_remote
fi

# download data
download_cmd=$(realpath ./sysadmin/download_if_different.sh)

# compare tool
cd ./bin
$download_cmd https://s3-us-west-2.amazonaws.com/merlin-ext/data/scans/cat_mickey.zip 92a077cb02d07dae875d960482c83984 cat_mickey.zip
$download_cmd https://s3-us-west-2.amazonaws.com/merlin-ext/data/scans/feet_from_tiger.zip e7adaa2c9abdedd293622ca8c5634526 feet_from_tiger.zip
$download_cmd https://s3-us-west-2.amazonaws.com/merlin-ext/data/scans/scans_from_orbbec_vg.zip 644a2a2e69a743a223d5a9cd4e9c9cd7 scans_from_orbbec_vg.zip
cd ../

# set binary dir variable
if [ -d ".build/gcc_x64" ]; then
    export BUILD_DIR="$(realpath .build/gcc_x64)"
fi
if [ -d ".build/v140_x64" ]; then
    export BUILD_DIR="$(realpath .build/v140_x64)"
fi
if [ -d ".build/v120_x64" ]; then
    export BUILD_DIR="$(realpath .build/v120_x64)"
fi

echo "BUILD_DIR env variable is set to " $BUILD_DIR
