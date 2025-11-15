# Create a stamp file based on local APT repo Release file to force mmdebstrap rebuild
# when the repo changes. Using Release file ensures we catch all metadata changes.
do_rootfs_prepare[stamp-extra-info] = "${@bb.utils.sha256_file('${LOCAL_APT_REPO}/dists/bookworm/Release') if os.path.exists('${LOCAL_APT_REPO}/dists/bookworm/Release') else 'no-repo'}"

# Mount local APT repo into chroot so APT can access file:// repository during do_rootfs_install
# The repo is already accessible in the kas container at /repo/isar-yocto-hybrid-demo/integration/local-apt
# We just need to make it accessible from inside the chroot
rootfs_do_mounts:append() {
    # Mount local APT repo so file:// repository is accessible from inside chroot
    LOCAL_APT_REPO_PATH=$(echo "${LOCAL_APT_REPO}" | sed 's|^file://||')
    MOUNT_POINT="${ROOTFSDIR}/repo/isar-yocto-hybrid-demo/integration/local-apt"
    
    if [ -d "${LOCAL_APT_REPO_PATH}" ]; then
        # Create the mount point directory itself (mount --bind requires the destination to exist)
        sudo mkdir -p "${MOUNT_POINT}"
        # Mount the repo into the chroot
        if sudo mount --bind "${LOCAL_APT_REPO_PATH}" "${MOUNT_POINT}" 2>&1; then
            bbnote "Mounted local APT repo: ${MOUNT_POINT}"
        else
            bbwarn "Failed to mount local APT repo: ${LOCAL_APT_REPO_PATH} -> ${MOUNT_POINT}"
        fi
    else
        bbwarn "Local APT repo path does not exist: ${LOCAL_APT_REPO_PATH}"
    fi
}

# Unmount local APT repo after rootfs operations
rootfs_do_umounts:prepend() {
    if mountpoint -q "${ROOTFSDIR}/repo/isar-yocto-hybrid-demo/integration/local-apt" 2>/dev/null; then
        sudo umount "${ROOTFSDIR}/repo/isar-yocto-hybrid-demo/integration/local-apt" || true
    fi
}

# Add Yocto-built packages to the image
# These packages will be installed from the local APT repository
ROOTFS_PACKAGES:append = " hybrid-demo-utils"

