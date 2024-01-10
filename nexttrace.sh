#!/bin/bash
for branch in `flatpak-spawn --host flatpak list --app --columns=application,arch,branch | grep io.github.Archeb.opentrace | sed 's#\t#/#g'`
do
    # generally those should be the same inode
    installdir=`flatpak-spawn --host flatpak info --show-location $branch`
    if ! flatpak-spawn --host getcap "$installdir/files/opentrace/_nexttrace" | grep cap_net_admin > /dev/null
    then
    #     echo "Setting up caps.."
        flatpak-spawn --host pkexec bash -c "setcap cap_net_raw,cap_net_admin+eip $installdir/files/opentrace/_nexttrace"
    fi
done
flatpak-spawn --host "$installdir/files/opentrace/_nexttrace" "$@"
