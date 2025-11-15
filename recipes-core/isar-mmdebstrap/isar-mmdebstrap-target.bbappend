# Fix qemu-aarch64-static copy issue in unshare namespace
# mmdebstrap tries to automatically copy qemu but fails in unshare mode
# We add a setup hook to manually copy it via MMHOOKS
python() {
    import os
    if os.path.exists('/usr/bin/qemu-aarch64-static'):
        qemu_hook = '--setup-hook="mkdir -p \\$1/usr/bin && cp /usr/bin/qemu-aarch64-static \\$1/usr/bin/qemu-aarch64-static && chmod +x \\$1/usr/bin/qemu-aarch64-static"'
        mmhooks = d.getVar('MMHOOKS') or ''
        if mmhooks:
            d.setVar('MMHOOKS', qemu_hook + ' ' + mmhooks)
        else:
            d.setVar('MMHOOKS', qemu_hook)
}

# Note: We've patched isar-mmdebstrap.inc to add "|| true" to the syncout command
# (line 148) to handle missing .deb files gracefully, matching syncin (line 145).
# This prevents mmdebstrap from aborting when no .deb files exist to sync on first run.

