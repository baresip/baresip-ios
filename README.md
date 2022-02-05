# Baresip for iOS


## Overview

[Baresip](https://github.com/baresip) is a modular SIP user-agent


## Build 

To build static libraries for iOS run the following command:
```shell
$ make download
$ make contrib
$ make xcframework
```

## Install
- Link XCode target with:
    - `contrib/xcframework/libbaresip.a.xcframework`, `contrib/xcframework/libre.a.xcframework`, `contrib/xcframework/librem.a.xcframework`  
    - `libresolv.9.dlyb`
    - `AVFoundation`, `SystemConfiguration`, `CFNetwork`, `CoreMedia`, `AudioToolbox`, `CoreVideo` frameworks

- Add to bridging headers
```
#import "re.h"
#import "rem.h"
#import "baresip.h"
```