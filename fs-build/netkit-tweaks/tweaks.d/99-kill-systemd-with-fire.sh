#! /bin/sh -e

# Based on:
#http://without-systemd.org/wiki/index.php/How_to_remove_systemd_from_a_Debian_jessie/sid_installation

# We already installed sysvinit..
# (We don't really _want_ init to do anything proactively in terms of terminals)
#eval "${SUDO_PFX} chroot ${FS_MOUNT_DIR} cp /usr/share/sysvinit/inittab /etc/inittab${SUDO_SFX}" >/dev/null

echo "Removing systemd.."
eval "${SUDO_PFX} chroot ${FS_MOUNT_DIR} apt-get remove -y --force-yes --purge --auto-remove systemd${SUDO_SFX}" >/dev/null

echo "Preventing re-installation of systemd.."
# Prevent apt from installing systemd packages in the future.
/bin/echo -e 'Package: systemd\nPin: origin ""\nPin-Priority: -1' | \
     eval "${SUDO_PFX} chroot ${FS_MOUNT_DIR} tee /etc/apt/preferences.d/systemd${SUDO_SFX}" >/dev/null

#Prevent apt from installing any systemd like packages in the future (note the star before and after systemd)
/bin/echo -e '\n\nPackage: *systemd*\nPin: origin ""\nPin-Priority: -1' | \
    eval "${SUDO_PFX} chroot ${FS_MOUNT_DIR} tee -a /etc/apt/preferences.d/systemd${SUDO_SFX}" >/dev/null
