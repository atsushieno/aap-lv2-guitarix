
ABIS_SIMPLE= x86 x86_64 armeabi-v7a arm64-v8a
ANDROID_NDK=$(ANDROID_SDK_ROOT)/ndk/21.2.6472646

all: build-all

build-all: \
	build-aap-lv2 \
	get-guitarix-deps \
	import-guitarix-deps \
	build-java

## downloads

get-guitarix-deps: dependencies/guitarix-deps/dist/stamp

dependencies/guitarix-deps/dist/stamp: aap-guitarix-binaries.zip
	unzip aap-guitarix-binaries.zip -d dependencies/guitarix-deps/
	for a in $(ABIS_SIMPLE) ; do \
		mkdir -p aap-guitarix/src/main/jniLibs/$$a ; \
		cp -R dependencies/guitarix-deps/dist/$$a/lib/*.so aap-guitarix/src/main/jniLibs/$$a ; \
	done
	touch dependencies/guitarix-deps/dist/stamp

aap-guitarix-binaries.zip:
	wget https://github.com/atsushieno/android-native-audio-builders/releases/download/r7/aap-guitarix-binaries.zip

androidaudioplugin-debug.aar:
	wget https://github.com/atsushieno/android-audio-plugin-framework/releases/download/v0.5.5/androidaudioplugin-debug.aar

# Run importers

import-guitarix-deps:
	./import-guitarix-deps.sh

## Build utility

build-aap-lv2:
	cd external/aap-lv2 && make build-non-app

build-java:
	ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) ./gradlew build
 
