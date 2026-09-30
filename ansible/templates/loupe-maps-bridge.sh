#!/usr/bin/env bash
#
# {{ ansible_managed }}
#
xdg-open "https://maps.google.com?q=${1#geo:}"
