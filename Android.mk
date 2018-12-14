LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

# The clang-tidy google-explicit-constructor warning is issued to nearly
# 1000 conversion constructors in this project. They are from more than
# 500 source files. Most of them should be declared explicit, but many
# of them need to be implicit. Until we correctly mark them as explicit
# or NOLINT(implicit), we suppress the google-explicit-constructor check.
LOCAL_TIDY_CHECKS := -google-explicit-constructor

deqp_dir := $(LOCAL_PATH)/

LOCAL_MODULE_TAGS := tests
LOCAL_MODULE := libdeqp

include $(LOCAL_PATH)/AndroidGen.mk

LOCAL_C_INCLUDES += \
	frameworks/native/opengl/include \
	external/deqp-deps/SPIRV-Headers/include \

deqp_compile_flags := \
	-DDEQP_SUPPORT_GLES1=1 \
	-DDE_ANDROID_API=28 \
	-D_XOPEN_SOURCE=600 \
	-DDEQP_TARGET_NAME=\"android\" \
	-DQP_SUPPORT_PNG=1 \
	-DDEQP_HAVE_GLSLANG=1 \
	-DDEQP_HAVE_SPIRV_TOOLS=1 \
	-Wall \
	-Werror \
	-Wconversion \
	-fwrapv \
	-Wno-implicit-fallthrough \
	-Wno-sign-conversion

LOCAL_SHARED_LIBRARIES := \
		libEGL \
		libGLESv2 \
		libandroid \
		liblog \
		libm \
		libc \
		libz \
		libdl

LOCAL_STATIC_LIBRARIES := \
		libpng_ndk \
		deqp_OSDependent \
		deqp_OGLCompiler \
		deqp_HLSL \
		deqp_glslang \
		deqp_SPIRV \
		deqp_spirv-tools \

LOCAL_CFLAGS += \
	$(deqp_compile_flags)

LOCAL_SDK_VERSION := 27
LOCAL_CPPFLAGS += \
		-Wno-non-virtual-dtor \
		-Wno-delete-non-virtual-dtor \
		-Wno-implicit-int-conversion \
		-Wno-missing-field-initializers \
		-Wno-switch \
		-Wno-unused-variable \

LOCAL_NDK_STL_VARIANT := c++_static
LOCAL_RTTI_FLAG := -frtti -fexceptions
LOCAL_MULTILIB := both
LOCAL_TIDY_CHECKS := \
    -google-build-explicit-make-pair, \
    -google-global-names-in-headers, \
    -google-runtime-member-string-references, \
    -google-runtime-operator, \

include $(BUILD_SHARED_LIBRARY)


# Build the test APKs using their own makefiles
# include $(call all-makefiles-under,$(LOCAL_PATH)/android)

include $(LOCAL_PATH)/android/package/Android.mk
