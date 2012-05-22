#!/bin/sh

cd $(dirname $0)

test "$1" = --remove && mode=remove || mode=add

cron_unique_label="Site Tunnel: $PWD"

# if crontab is executable
if type crontab >/dev/null 2>/dev/null; then
    if test $mode = add; then
	# if this crontab entry is not added yet
	if ! crontab -l 2>/dev/null | grep "^# $cron_unique_label" >/dev/null 2>/dev/null; then
	    # creating crontab line
	    mkdir -p logs
	    workfile=.$(basename $0)-$$
	    trap 'rm -f $workfile; exit 1;' 1 2 3 15
	    cat <<EOF >$workfile
# $cron_unique_label
0	*	*	*	*	$PWD/autossh.sh

EOF
	    echo 'Appending to crontab:'
	    cat $workfile
	    crontab -l 2>/dev/null | cat - $workfile | crontab -
	    rm -f $workfile
	else
	    echo 'Crontab entry already exists, skipping ...'
	fi
    elif test $mode = remove; then
	# if this crontab entry exists
	if crontab -l 2>/dev/null | grep "^# $cron_unique_label" >/dev/null 2>/dev/null; then
	    # creating sed file
	    workfile=.$(basename $0)-$$
	    trap 'rm -f $workfile; exit 1;' 1 2 3 15
	    cat <<EOF >$workfile
\?^# $cron_unique_label? {
: next
n
/./ b next
d
}
p
EOF
	    echo Removing crontab entry ...
	    crontab -l 2>/dev/null | sed -nf $workfile | crontab -
	    rm -f $workfile
	else
	    echo Crontab entry does not exist, nothing to do.
	fi
    fi
fi

# eof
