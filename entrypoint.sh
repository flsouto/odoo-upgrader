#!/bin/sh

pg_ctlcluster 12 main start &

[[ -f ./child-entrypoint.sh ]] && ./child-entrypoint.sh

exec "sh"
