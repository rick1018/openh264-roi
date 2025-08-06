#!/bin/bash

# Author: AlanWang
# Email: alanwang4523@gmail.com
# Date: 2020-06-30
# https://github.com/cisco/openh264/tree/v2.1.1

# 需要指定 ANDROID_NDK 和 ANDROID_NDK
export ANDROID_SDK=YOUR_ANDROID_SDK_PATH
export ANDROID_NDK=YOUR_ANDROID_NDK_PATH
export PATH=$ANDROID_SDK/tools:$PATH

function build_openh264 {
  ABI=$1
  API_LEVEL=$2

  case $ABI in
    armeabi-v7a )
      ARCH=arm
      ;;
    arm64-v8a )
      ARCH=arm64
      ;;
    x86 )
      ARCH=x86
      ;;
    x86_64 )
      ARCH=x86_64
      ;;
  esac

  TARGET_OS=android
  ANDROID_TARGET=android-$API_LEVEL
  BUILD_PREFIX=$(pwd)/libs/openh264-out/$ABI

  echo "build libopenh264 ${ABI} ${ANDROID_TARGET}"
  echo "build libopenh264 ${ABI} output : ${BUILD_PREFIX}"

  make \
      OS=${TARGET_OS} \
      NDKROOT=$ANDROID_NDK \
      TARGET=$ANDROID_TARGET \
      ARCH=$ARCH \
      clean
  make \
      OS=${TARGET_OS} \
      NDKROOT=$ANDROID_NDK \
      TARGET=$ANDROID_TARGET \
      NDKLEVEL=$API_LEVEL \
      ARCH=$ARCH \
      PREFIX=$BUILD_PREFIX \
      -j4 install
}


ROOT_PATH=$(pwd)
OPENH264_SOURCE_DIR=$ROOT_PATH
mkdir -p $ROOT_PATH/libs

if [[ ! -d $OPENH264_SOURCE_DIR ]]; then
  echo "Did not found $OPENH264_SOURCE_DIR"
  exit 1
fi

cd $OPENH264_SOURCE_DIR

build_openh264 armeabi-v7a 16
build_openh264 arm64-v8a 21