#!/bin/sh -e

cd $(dirname "$0")

test "$1" = --remove && mode=remove || mode=add

cron_unique_label="# $PWD"

crontab="$0".crontab
test -f $crontab || cp $crontab.sample $crontab

workfile="$0".tmp
cleanup() { rm -f "$workfile"; }
trap 'cleanup; exit 1;' 1 2 3 15

# if crontab is executable
if type crontab >/dev/null 2>/dev/null; then
    if test $mode = add; then
        # if this crontab is not added yet
        if ! crontab -l 2>/dev/null | grep -x "$cron_unique_label" >/dev/null 2>/dev/null; then
            export cron_unique_label
            cat $crontab | perl -ne 's/\$(\w+)/$ENV{$+}/g; print' >$workfile
            echo 'Appending to crontab:'
            cat $workfile
            crontab -l 2>/dev/null | cat - $workfile | crontab -
        else
            echo 'Crontab entry already exists, skipping ...'
            echo
        fi
        echo "To remove previously added crontab entry, run: $0 --remove"
        echo
    elif test $mode = remove; then
        # if this crontab entry exists
        if crontab -l 2>/dev/null | grep -x "$cron_unique_label" >/dev/null 2>/dev/null; then
            echo Removing crontab entry ...
            crontab -l 2>/dev/null | sed -e "\?^$cron_unique_label\$?,/^\$/ d" | crontab -
        else
            echo Crontab entry does not exist, nothing to do.
        fi
    fi
fi

cleanup

# eof
