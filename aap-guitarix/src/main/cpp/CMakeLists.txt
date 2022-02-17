cmake_minimum_required(VERSION 3.10)

project(aap-guitarix)

set(GUITARIX_DIR ../../../../external/guitarix/trunk)
set(FFTW3_DIR ../../../../fftw3-aar/src/main/cpp/fftw-3.3.10)

include(cmake/CPM.cmake)

CPMAddPackage(
	NAME libsigc++
	GITHUB_REPOSITORY libsigcplusplus/libsigcplusplus
	GIT_TAG 3.2.0
)
find_package(libsigc++)

FILE(GLOB PLUGIN_LV2_DIRS ${GUITARIX_DIR}/src/LV2/gx*)
list(SORT PLUGIN_LV2_DIRS)
set(LV2_SUBDIR_DENY_LIST
	"gxpreamp"
	"gx_vibe"
	"gx_jalv_runner"
)

foreach(PLUGIN_DIR IN ITEMS ${PLUGIN_LV2_DIRS})
	
	get_filename_component(PLUGIN_NAME ${PLUGIN_DIR} NAME_WE)

	if (PLUGIN_NAME IN_LIST LV2_SUBDIR_DENY_LIST)
		continue()
	endif()

    get_filename_component(PLUGIN_DIR_FULL_PATH ${PLUGIN_DIR} ABSOLUTE)
	FILE(GLOB PLUGIN_SOURCES "${PLUGIN_DIR_FULL_PATH}/gx*.cpp")
	list(FILTER PLUGIN_SOURCES EXCLUDE REGEX ".*_ui.cpp")
	list(FILTER PLUGIN_SOURCES EXCLUDE REGEX ".*gui.cpp")
	list(FILTER PLUGIN_SOURCES EXCLUDE REGEX "widget.cpp")
	list(FILTER PLUGIN_SOURCES EXCLUDE REGEX "gx_pitch_tracker.cpp")

	message ("Generating build rules for ${PLUGIN_NAME} ...")

	add_library(${PLUGIN_NAME}
		SHARED
		${PLUGIN_SOURCES}
	)

    set_target_properties(${PLUGIN_NAME}
        PROPERTIES PREFIX ""
    )

    target_include_directories( ${PLUGIN_NAME}
        PRIVATE
		"${GUITARIX_DIR}/src/headers"
		"${GUITARIX_DIR}/src/plugins"
		"${GUITARIX_DIR}/src/LV2/DSP"
		"${GUITARIX_DIR}/src/LV2/DSP/circuit_tables"
		"${GUITARIX_DIR}/src/LV2/faust-generated"
		"${GUITARIX_DIR}/src/zita-resampler-1.1.0"
		"${GUITARIX_DIR}/src/zita-convolver"
        ./include
        ./include/lv2/core
		"${FFTW3_DIR}/api"
		"${libsigc++_INCLUDE_DIRS}"
        "${Project_SOURCE_DIR}/../../../../../../native/plugin-api/include"
        "${Project_SOURCE_DIR}/../../../../../../native/androidaudioplugin/core/include"
        "${Project_SOURCE_DIR}/../../../../../../native/androidaudioplugin/android/src/gen/include"
    )

	target_include_directories(${PLUGIN_NAME} PRIVATE ../../../../fftw3-aar/src/main/cpp/fftw-3.3.10)
	
    target_link_libraries( ${PLUGIN_NAME} android log fftw3 ${libsigc++_LIBRARIES})

    # set non-zero this if you want to debug with AddressSanitizer
    set(AAP_DEBUG_WITH_ASAN 0)

    if (AAP_DEBUG_WITH_ASAN)
        target_compile_options (${PLUGIN_NAME}
                PUBLIC
                -fsanitize=address -fno-omit-frame-pointer
                )

        target_link_options(${PLUGIN_NAME}
                PUBLIC
                -fsanitize=address
                )

        set_target_properties(${PLUGIN_NAME}
                PROPERTIES LINK_FLAGS -fsanitize=address
                )
    endif()

endforeach()
