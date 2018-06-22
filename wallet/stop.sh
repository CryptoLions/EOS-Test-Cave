#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# keosd EOS wallet stop script
#
# https://github.com/CryptoLions/
#
################################################################################
config="../config.json"
DIR="$( jq -r '.wallet_data_dir' "$config" )"

    if [ -f $DIR"/wallet.pid" ]; then
        pid=$(cat $DIR"/wallet.pid")
        echo $pid
        kill $pid
        rm -r $DIR"/wallet.pid"

        echo -ne "Stoping Wallet"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rWallet stopped. \n"

    fi
    
