#!/bin/sh
# Filename:      grml-policy-rc.d
# Purpose:       interface script for invoke-rc.d (see /etc/policy-rc.d.conf)
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
# Latest change: Mit Okt 18 20:43:22 UTC 2006 [mika]
################################################################################

# test for chroot
if test "$(/usr/bin/stat -c "%d/%i" /)" != "$(/usr/bin/stat -Lc "%d/%i" /proc/1/root 2>/dev/null)" ; then
   # notify invoke-rc.d that nothing should be done -- we are in a chroot
   exit 101
fi

# read configuration file
if [ -r /etc/policy-rc.d.conf ] ; then
   . /etc/policy-rc.d.conf
fi

if [ -n "$EXITSTATUS" ]; then
   exit "$EXITSTATUS"
else
   # allow it
   exit 0
fi

## END OF FILE #################################################################
