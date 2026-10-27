################################################################################
#
# iio-vrt49
#
################################################################################

IIO_VRT49_VERSION = 6947b205f931c8ca5bd08f9e1891b7667822b4bb

# plutosdr-fw pins the same commit as its vrt49 submodule and builds that
# checkout in place. Without it, fetch with git: the repository is private,
# so GitHub tarballs are not downloadable.
ifeq ($(wildcard $(BR2_EXTERNAL_ADI_PATH)/../vrt49/.git),)
IIO_VRT49_SITE = https://github.com/tfcollins/vrt49.git
IIO_VRT49_SITE_METHOD = git
else
IIO_VRT49_VERSION = custom
IIO_VRT49_SITE = $(BR2_EXTERNAL_ADI_PATH)/../vrt49
IIO_VRT49_SITE_METHOD = local
endif

IIO_VRT49_LICENSE = LGPL-2.1+
IIO_VRT49_LICENSE_FILES = LICENSE
IIO_VRT49_DEPENDENCIES = libiio

IIO_VRT49_CONF_OPTS = \
	-DVRT49_BUILD_IIOD_TRANSPORT=ON \
	-DVRT49_BUILD_BACKEND=OFF \
	-DVRT49_BUILD_KERNEL=OFF \
	-DVRT49_BUILD_HDL_SIM=OFF \
	-DVRT49_BUILD_TESTS=OFF \
	-DVRT49_BUILD_TOOLS=OFF \
	-DVRT49_BUILD_EXAMPLES=OFF \
	-DBUILD_SHARED_LIBS=OFF

define IIO_VRT49_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_ADI_PATH)/package/iio-vrt49/S65iiod-vrt49 $(TARGET_DIR)/etc/init.d/S65iiod-vrt49
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_ADI_PATH)/package/iio-vrt49/iiod-vrt49.default $(TARGET_DIR)/etc/default/iiod-vrt49
endef

define IIO_VRT49_INSTALL_SYMLINK
	ln -sf iiod-vrt49 $(TARGET_DIR)/usr/bin/iio-vrt49
endef
IIO_VRT49_POST_INSTALL_TARGET_HOOKS += IIO_VRT49_INSTALL_SYMLINK

$(eval $(cmake-package))
