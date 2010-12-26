#!/bin/sh
# Filename:      policy-rc.d
# Purpose:       interface script for invoke-rc.d (see /etc/policy-rc.d.conf)
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################

## test for chroot
# make sure /proc/1/root can be read, if not either /proc is not mounted
# or it is not executed with root permissions (and "sudo invoke-rc.d $service"
# might fail), if so don't continue
if [ -d /proc/1 ] && readlink -f /proc/1/root >/dev/null 2>&1; then
  if test "$(/usr/bin/stat -c "%d/%i" /)" != "$(/usr/bin/stat -Lc "%d/%i" /proc/1/root 2>/dev/null)" ; then
     # notify invoke-rc.d that nothing should be done -- we are in a chroot
     exit 101
  fi
fi

# read configuration file
if [ -z "$POLICYRCD" ] ; then
  if [ -r /etc/policy-rc.d.conf ] ; then
     . /etc/policy-rc.d.conf
  fi
fi

if [ -z "$POLICYRCD" ]; then
  for file in /usr/local/sbin/policy-rc.d /etc/policy-rc.d; do
    if [ -x "$file" ]; then
      POLICYRCD="$file"
      break
    fi
  done
fi

# if $POLICYRCD is set or either /usr/local/sbin/policy-rc.d
# or /etc/policy-rc.d are present execute them:
if [ -n "$POLICYRCD" ]; then
  $POLICYRCD "$@"
  exit $?
else
  # otherwise exit with $EXITSTATUS,
  # being '0' by default
  if [ -n "$EXITSTATUS" ]; then
     exit "$EXITSTATUS"
  else
     # or if $EXITSTATUS isn't set just allow it
     exit 0
  fi
fi

## END OF FILE #################################################################
