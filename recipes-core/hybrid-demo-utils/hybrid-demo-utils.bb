SUMMARY = "Hybrid demo C++ application with JSON parsing"
DESCRIPTION = "A C++ application with CMake build system and JSON configuration parsing"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://hybrid-demo.cpp \
    file://CMakeLists.txt \
    file://demo-file.txt \
    file://config.json \
    file://hybrid-demo.service \
"

S = "${WORKDIR}"
DEPENDS = "nlohmann-json"

inherit cmake systemd

# CMake will handle compilation and installation
# Override install to ensure all files are included
do_install:append() {
    # Install data files (CMake should handle this, but ensure it's done)
    install -d ${D}${datadir}/hybrid-demo
    install -m 0644 ${S}/demo-file.txt ${D}${datadir}/hybrid-demo/
    install -m 0644 ${S}/config.json ${D}${datadir}/hybrid-demo/
    
    # Install systemd service file
    # Note: Using ${libdir} directly instead of ${systemd_system_unitdir} because
    # systemd_system_unitdir is not defined in Yocto Langdale's systemd class
    install -d ${D}${libdir}/systemd/system
    install -m 0644 ${S}/hybrid-demo.service ${D}${libdir}/systemd/system/
    
    # Manually enable the service by creating symlink
    # SYSTEMD_AUTO_ENABLE may not be supported in Yocto Langdale
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
    # Use absolute path for symlink target (${libdir} = /usr/lib on target)
    ln -sf /usr/lib/systemd/system/hybrid-demo.service \
           ${D}${sysconfdir}/systemd/system/multi-user.target.wants/hybrid-demo.service
}

FILES:${PN} = " \
    ${bindir}/hybrid-demo \
    ${datadir}/hybrid-demo/* \
    ${libdir}/systemd/system/hybrid-demo.service \
    ${sysconfdir}/systemd/system/multi-user.target.wants/hybrid-demo.service \
"

# Enable the service by default
SYSTEMD_SERVICE:${PN} = "hybrid-demo.service"
# Note: SYSTEMD_AUTO_ENABLE may not work in Yocto Langdale, so we manually create
# the symlink in do_install:append() above
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

# Prevent systemd class from creating a separate package
SYSTEMD_PACKAGES = "${PN}"

# Package as .deb for ISAR
PACKAGE_CLASSES = "package_deb"

