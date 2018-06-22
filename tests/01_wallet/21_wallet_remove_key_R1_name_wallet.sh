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


if [[ ! $GLOBALPATH ]]; then
    GLOBALPATH="$(dirname $(realpath $0))/../.."
fi

config="$GLOBALPATH/config.json"
NAME="$( jq -r '.wallet_test_name' "$config" )"

TEST_NAME="Wallet remove_key R1 from $NAME wallet"

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#--------------------------------------------------
WPASS=$(cat $GLOBALPATH/log/wallet_name_"$NAME"_password.dat)
PUB_KEY=$(cat $GLOBALPATH/log/wallet_create_key_name_r1.dat)

CMD1=$($GLOBALPATH/bin/cleos.sh wallet remove_key -n $NAME --password $WPASS $PUB_KEY 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)
if [[ $ERR != "" ]]; then
    failed "$ERR";
    rm $tpm_stderr;
    exit
fi


CMD=$($GLOBALPATH/bin/cleos.sh wallet keys 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ "$CMD" != *"$PUB_KEY"* ]]; then
    echo "1:$TEST_NAME"
else
    failed "K1 key was not removed from $NAME wallet"
fi




