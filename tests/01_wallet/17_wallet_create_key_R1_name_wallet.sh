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

TEST_NAME="Wallet create_key R1 in $NAME wallet"

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#--------------------------------------------------
CMD1=$($GLOBALPATH/bin/cleos.sh wallet create_key -n $NAME R1 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)
if [[ $ERR != "" ]]; then
    failed "$ERR";
    rm $tpm_stderr;
    exit
fi


CMD1_=${CMD1// /}
CMD1_=${CMD1_//\"/}
CMD1_=(${CMD1_//:/ })
PUB_KEY=${CMD1_[1]}

CMD=$($GLOBALPATH/bin/cleos.sh wallet keys 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ "$CMD" == *"$PUB_KEY"* ]]; then
    echo "$PUB_KEY" >> $GLOBALPATH/log/wallet_create_key_name_r1.dat
    echo "1:$TEST_NAME"
else
    failed "Key not found in $NAME wallet"
fi




