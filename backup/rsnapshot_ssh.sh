#!/bin/bash

#. `dirname "$0"`/includes.sh

. $HOME/.keychain/$HOSTNAME-sh

rsnapshot $@
