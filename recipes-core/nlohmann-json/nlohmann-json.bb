SUMMARY = "JSON for Modern C++ (header-only library)"
DESCRIPTION = "nlohmann/json is a header-only C++ library for JSON parsing"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Download the single header file from GitHub releases
# Version 3.11.2 - header-only library
SRC_URI = "https://github.com/nlohmann/json/releases/download/v3.11.2/json.hpp"
SRC_URI[sha256sum] = "665fa14b8af3837966949e8eb0052d583e2ac105d3438baba9951785512cf921"

S = "${WORKDIR}"

# This is a header-only library, so we just install the header
do_install() {
    install -d ${D}${includedir}/nlohmann
    install -m 0644 ${S}/json.hpp ${D}${includedir}/nlohmann/
}

# Header-only library, no binaries
FILES:${PN}-dev = "${includedir}/nlohmann/*"
FILES:${PN} = ""

# Package as .deb for ISAR
PACKAGE_CLASSES = "package_deb"

