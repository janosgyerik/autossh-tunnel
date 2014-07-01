#!/bin/sh -e
# 
# File: list.sh
# Purpose: show all running autossh screen sessions
#

screen -ls | grep -F .autossh-
