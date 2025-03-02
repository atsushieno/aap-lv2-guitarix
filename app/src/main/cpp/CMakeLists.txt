cmake_minimum_required(VERSION 3.6.0)

add_library(aap-guitarix SHARED
        "dummy.cpp"
        )

target_include_directories(aap-guitarix
        PRIVATE
        "${Project_SOURCE_DIR}/../../../include"
        )

target_compile_options(aap-guitarix
        PRIVATE
        -std=c++17
        -Wall
        -Wextra-semi
        -Wshadow
        -Wshadow-field
        )

target_link_libraries(aap-guitarix android log)

find_package (androidaudioplugin REQUIRED CONFIG)
target_link_libraries(aap-guitarix
        android
        log
        androidaudioplugin::androidaudioplugin
)

# uncomment this if you want to enable AddressSanitizer
#set_target_properties(aap-guitarix PROPERTIES LINK_FLAGS -fsanitize=address)
