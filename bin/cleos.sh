#!/bin/bash
################################################################################
#
# EOS Cleos wrapper
# 
# Created by http://CryptoLions.io
#
# Git Hub: https://github.com/CryptoLions
# Eos Network Monitor: http://eosnetworkmonitor.io/
#
###############################################################################

SCRIPTPATH=$(dirname $(realpath $0))""
config="$SCRIPTPATH/../config.json"
WALLETHOST="$( jq -r '.walletAddr' "$config" )"
NODEHOST="$( jq -r '.nodeos' "$config" )"


$SCRIPTPATH/bin/cleos -u http://$NODEHOST --wallet-url http://$WALLETHOST "$@"
