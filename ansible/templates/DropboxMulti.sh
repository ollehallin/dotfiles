#!/usr/bin/env bash
#
# {{ ansible_managed }}
#

REAL_HOME=$HOME

for dropbox in .dropbox-personal; do
    echo -n "$dropbox "; read
    DROPBOXD="$REAL_HOME/$dropbox/.dropbox-dist/dropboxd"
    if ! [ -f "$DROPBOXD" ]; then
        mkdir -p "$REAL_HOME/$dropbox"
        if [ ! -l "$REAL_HOME/$dropbox/.Xauthority" ]; then
            ln -s "$REAL_HOME/.Xauthority" "$REAL_HOME/$dropbox/"
        fi
	cp -r $REAL_HOME/.dropbox-dist "$REAL_HOME/$dropbox"
    fi
    HOME="$REAL_HOME/$dropbox" nice $DROPBOXD > /tmp/${dropbox}.out 2>&1 &
done
