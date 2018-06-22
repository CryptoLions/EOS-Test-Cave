#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# keosd EOS wallet start script
#
# https://github.com/CryptoLions/
#
################################################################################
config="../config.json"
KEOSD="$( jq -r '.bin' "$config" )"/keosd
DATADIR="$( jq -r '.wallet_data_dir' "$config" )"
WALLET_ADDR="($( jq -r '.walletAddr' "$config" )"


$DATADIR/stop.sh
../bin/bin/keosd --wallet-dir $DATADIR --data-dir $DATADIR --http-server-address $WALLET_ADDR "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt  & echo $! > $DATADIR/wallet.pid
#../bin/bin/keosd --http-server-address $WALLET_ADDR "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt  & echo $! > $DATADIR/wallet.pid
echo "Wallet started"
