#!/bin/bash

ABIS_SIMPLE=(x86 x86_64 armeabi-v7a arm64-v8a)

# Remove existing jniLibs for sanity
rm -rf app/src/main/jniLibs/
rm -rf app/src/main/assets/lv2/

# copy shared libs
for abi in ${ABIS_SIMPLE[*]}
do
    echo "ABI: $abi"
    # Copy native libs for each ABI
    mkdir -p app/src/main/jniLibs/$abi
    cp -R dependencies/guitarix-deps/dist/$abi/lib/*.so app/src/main/jniLibs/$abi/
    # And then copy native libs of LV2 plugins for each ABI.
    mkdir -p app/src/main/jniLibs/$abi
    cp -R dependencies/guitarix-deps/dist/$abi/lib/lv2/*/*.so app/src/main/jniLibs/$abi/
done

# copy manifests
mkdir -p app/src/main/assets/lv2
cp -R dependencies/guitarix-deps/dist/x86/lib/lv2/*.lv2 app/src/main/assets/lv2/
# ... except for *.so files. They are stored under jniLibs.
rm app/src/main/assets/lv2/*/*.so


# import metadata
mkdir -p app/src/main/assets/lv2
mkdir -p app/src/main/res/xml
external/aap-lv2/tools/aap-import-lv2-metadata/build/aap-import-lv2-metadata \
        app/src/main/assets/lv2 \
        app/src/main/res/xml

