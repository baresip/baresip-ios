#!/bin/bash

FAT_PATH="contrib/fat/lib"

LIBBARESIP="libbaresip.a"
LIBRE="libre.a"
LIBREM="librem.a"

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

xcodebuild -create-xcframework -library ./$IPHONEOS/$LIBBARESIP -library ./$IPHONESIMULATOR/$LIBBARESIP -output "$XCFRAMEWORK/$LIBBARESIP.xcframework"
xcodebuild -create-xcframework -library ./$IPHONEOS/$LIBRE -library ./$IPHONESIMULATOR/$LIBRE -output "$XCFRAMEWORK/$LIBRE.xcframework"
xcodebuild -create-xcframework -library ./$IPHONEOS/$LIBREM -library ./$IPHONESIMULATOR/$LIBREM -output "$XCFRAMEWORK/$LIBREM.xcframework"
