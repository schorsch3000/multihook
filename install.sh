#!/usr/bin/env bash

if [ $# -ne '2' ] ; then
echo "USAGE: $0 <git template dir> <path to multihook.sh>"
exit
fi

HOOK_PATH=$(realpath "$2")
cd $1
DATE=$(date +%Y-%m-%d_%H:%M:%S)
mkdir -p hooks
cd hooks
mkdir -p backup/$DATE
mv * backup/$DATE 2>/dev/null

ln -s "$HOOK_PATH" multihook

HOOKLIST="pre-applypatch applypatch-msg post-applypatch pre-commit prepare-commit-msg commit-msg post-commit pre-rebase post-checkout post-merge pre-push pre-receive update post-receive post-update push-to-checkoutpre-auto-gc post-rewrite"

for HOOK in $HOOKLIST ; do
ln -s multihook $HOOK
done