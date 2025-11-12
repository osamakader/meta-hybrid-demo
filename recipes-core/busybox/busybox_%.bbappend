# Example: enable extra applets and customize the busybox build

FILESEXTRAPATHS:append := ":${THISDIR}/files"

SRC_URI:append = " file://busybox.config"

PV = "${PV}+hybrid"

do_configure:append() {
    # Tag the build so we can see it in binaries
    printf '\nconst char hybrid_demo_version[] = "hybrid-demo";\n' >> applets/applets.c
}
