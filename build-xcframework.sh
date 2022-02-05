#!/bin/bash

FAT_PATH="contrib/fat/lib"

LIBBARESIP="libbaresip.a"
LIBRE="libre.a"
LIBREM="librem.a"

LIBBARESIP_HEADERS="baresip/include"
LIBRE_HEADERS="re/include"
LIBREM_HEADERS="rem/include"

IPHONEOS="contrib/iphonesimulator"
IPHONESIMULATOR="contrib/iphoneos"
XCFRAMEWORK="contrib/xcframework"

mkdir -p $IPHONEOS
mkdir -p $IPHONESIMULATOR
mkdir -p $XCFRAMEWORK

test -f "$FAT_PATH/$LIBBARESIP" && echo "$LIBBARESIP exists."
test -f "$FAT_PATH/$LIBRE" && echo "$LIBRE exists."
test -f "$FAT_PATH/$LIBREM" && echo "$LIBREM exists."

# device
xcrun lipo -remove x86_64 -remove armv7 -remove armv7s $FAT_PATH/$LIBBARESIP -o ./$IPHONEOS/$LIBBARESIP
xcrun lipo -remove x86_64 -remove armv7 -remove armv7s $FAT_PATH/$LIBRE -o ./$IPHONEOS/$LIBRE
xcrun lipo -remove x86_64 -remove armv7 -remove armv7s $FAT_PATH/$LIBREM -o ./$IPHONEOS/$LIBREM

# simulator
xcrun lipo -remove arm64 -remove armv7 -remove armv7s $FAT_PATH/$LIBBARESIP -o ./$IPHONESIMULATOR/$LIBBARESIP
xcrun lipo -remove arm64 -remove armv7 -remove armv7s $FAT_PATH/$LIBRE -o ./$IPHONESIMULATOR/$LIBRE
xcrun lipo -remove arm64 -remove armv7 -remove armv7s $FAT_PATH/$LIBREM -o ./$IPHONESIMULATOR/$LIBREM

# m1 arm simulator
# https://developer.apple.com/forums/thread/66633

IOS_ARM_SIM_LIBBARESIP="contrib/slim/lib/libbaresip.a"
IOS_ARM_SIM_LIBRE="contrib/slim/lib/libre.a"
IOS_ARM_SIM_LIBREM="contrib/slim/lib/librem.a"

xcodebuild -create-xcframework \
-library ./$IPHONEOS/$LIBBARESIP -headers ./$LIBBARESIP_HEADERS \
-library ./$IPHONESIMULATOR/$LIBBARESIP -headers ./$LIBBARESIP_HEADERS \
-output "$XCFRAMEWORK/$LIBBARESIP.xcframework"

xcodebuild -create-xcframework \
-library ./$IPHONEOS/$LIBRE -headers ./$LIBRE_HEADERS \
-library ./$IPHONESIMULATOR/$LIBRE -headers ./$LIBRE_HEADERS \
-output "$XCFRAMEWORK/$LIBRE.xcframework"

xcodebuild -create-xcframework \
-library ./$IPHONEOS/$LIBREM -headers ./$LIBREM_HEADERS \
-library ./$IPHONESIMULATOR/$LIBREM -headers ./$LIBREM_HEADERS \
-output "$XCFRAMEWORK/$LIBREM.xcframework"

lipo $XCFRAMEWORK/$LIBBARESIP.xcframework/ios-x86_64-simulator/libbaresip.a $IOS_ARM_SIM_LIBBARESIP -create -output $XCFRAMEWORK/$LIBBARESIP.xcframework/ios-x86_64-simulator/libbaresip.a
lipo $XCFRAMEWORK/$LIBRE.xcframework/ios-x86_64-simulator/libre.a $IOS_ARM_SIM_LIBRE -create -output $XCFRAMEWORK/$LIBRE.xcframework/ios-x86_64-simulator/libre.a
lipo $XCFRAMEWORK/$LIBREM.xcframework/ios-x86_64-simulator/librem.a $IOS_ARM_SIM_LIBREM -create -output $XCFRAMEWORK/$LIBREM.xcframework/ios-x86_64-simulator/librem.a
