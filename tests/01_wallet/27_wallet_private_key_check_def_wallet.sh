#!/bin/bash
################################################################################
#
# EOS Testing cave
#
# Created by Bohdan Kossak
# 2018 CryptoLions.io
#
# For automated testing EOS software
#
# Git Hub: https://github.com/CryptoLions
# Eos Network Monitor: http://eosnetworkmonitor.io/
#
# 
###############################################################################
TEST_NAME="Wallet private_key check in default wallet"

if [[ ! $GLOBALPATH ]]; then
    GLOBALPATH="$(dirname $(realpath $0))/../.."
fi

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#--------------------------------------------------
KEY=($(cat $GLOBALPATH/log/wallet_default_key.dat))
WPASS=$(cat $GLOBALPATH/log/wallet_default_password.dat)


CMD=$($GLOBALPATH/bin/cleos.sh wallet private_keys --password $WPASS 2>$tpm_stderr)


ERR=$(cat $tpm_stderr)
if [[ $ERR != "" ]]; then
    failed "$ERR";
    rm $tpm_stderr;
    exit
fi


if [[ "$CMD" == *"${KEY[1]}"* ]]; then
    echo "1:$TEST_NAME"
else
    failed "Key not found in default wallet"
fi




