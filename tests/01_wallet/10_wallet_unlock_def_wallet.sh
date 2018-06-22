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
TEST_NAME="Wallet unlock default wallet"

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

#----------------------------------------------------------------------------------------------
WPASS=$(cat $GLOBALPATH/log/wallet_default_password.dat)
CMD=$($GLOBALPATH/bin/cleos.sh wallet unlock --password "$WPASS" 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ $ERR != "" ]]; then
    failed "$ERR";
    rm $tpm_stderr;
else
    DATA=($CMD)
    if [[ "${DATA[0]}" == "Unlocked:" && "${DATA[1]}" == "default" ]]; then
        echo "1:$TEST_NAME"
    else
        failed "Wallet not unlocked";
    fi


fi




