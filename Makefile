
PWD=$(shell pwd)
AAP_LV2_DIR=$(PWD)/external/aap-lv2
ABIS_SIMPLE= x86 x86_64 armeabi-v7a arm64-v8a
ANDROID_NDK=$(ANDROID_SDK_ROOT)/ndk/21.3.6528147

all: build-all

build-all: \
	build-aap-lv2 \
	get-guitarix-deps \
	import-guitarix-deps \
	build-java

build-aap-lv2:
	cd $(AAP_LV2_DIR) && make

## downloads

get-guitarix-deps: dependencies/guitarix-deps/dist/stamp

dependencies/guitarix-deps/dist/stamp: aap-guitarix-binaries.zip
	unzip aap-guitarix-binaries.zip -d dependencies/guitarix-deps/
	for a in $(ABIS_SIMPLE) ; do \
		mkdir -p app/src/main/jniLibs/$$a ; \
		cp -R dependencies/guitarix-deps/dist/$$a/lib/*.so app/src/main/jniLibs/$$a ; \
	done
	touch dependencies/guitarix-deps/dist/stamp

aap-guitarix-binaries.zip:
	wget https://github.com/atsushieno/android-native-audio-builders/releases/download/r8.3/aap-guitarix-binaries.zip

# Run importers

import-guitarix-deps:
	./import-guitarix-deps.sh

## Build utility

build-java:
	ANDROID_SDK_ROOT=$(ANDROID_SDK_ROOT) ./gradlew build
 
