# Disabled: Use Debian's busybox package instead of rebuilding from Yocto
# This avoids patching issues and uses the well-tested Debian package
# 
# To re-enable Yocto-built busybox, uncomment the lines below:
#
# FILESEXTRAPATHS:append := ":${THISDIR}/files"
# SRC_URI:append = " \
#     file://busybox.config \
#     file://0001-addgroup-add-quiet-option.patch \
#     file://0002-modprobe-add-all-long-option.patch \
#     "
# PE = "2"
# PR:append = "+hybrid"
# RDEPENDS:${PN}:remove = "update-alternatives-opkg"
# do_configure:append() {
#     # Ensure CONFIG_EXTRA_VERSION is set in the config after merge
#     if [ -f .config ]; then
#         sed -i 's|^CONFIG_EXTRA_VERSION=.*|CONFIG_EXTRA_VERSION="hybrid-demo"|' .config || echo 'CONFIG_EXTRA_VERSION="hybrid-demo"' >> .config
#     fi
#     # Tag the build so we can see it in binaries
#     if ! grep -q "hybrid_demo_version" applets/applets.c; then
#         printf '\nconst char hybrid_demo_version[] = "hybrid-demo";\n' >> applets/applets.c
#     fi
# }
# do_compile:prepend() {
#     # Ensure EXTRAVERSION is set in the Makefile or config before compilation
#     if [ -f include/autoconf.h ]; then
#         sed -i 's|^#define CONFIG_EXTRA_VERSION.*|#define CONFIG_EXTRA_VERSION "hybrid-demo"|' include/autoconf.h || \
#         echo '#define CONFIG_EXTRA_VERSION "hybrid-demo"' >> include/autoconf.h
#     fi
# }
