# nodes_alpine

Tried to work with Node.js Alpine linux APK build with [andyshinn's docker alpine abuild tool](https://github.com/andyshinn/docker-alpine-abuild). 

Seems having [problem](https://github.com/andyshinn/docker-alpine-abuild/issues/9) (attr_set not supported) on Mac OSX xhyve, so have this repo created for workaround, if you prefer to stick on official APKBUILD file.

**UPDATE**: For people would like not use any VM at all, simple switch off `paxmark` with `paxctl`, and replace all:

```
paxmark -c /path/to/target
```

to

```
paxctl -cm /path/to/target
```

Have tested this work under Mac OS X El Capitan & Docker 1.12.1.
