#!/bin/bash
################################################################################
#
# EOS Testing cave
#
# Created by Bohdan Kossak
# 2018 CryptoLions.io
# For automated testing EOS software
#
# Git Hub: https://github.com/CryptoLions
# Eos Network Monitor: http://eosnetworkmonitor.io/
#
###############################################################################

GLOBALPATH=$(dirname $(realpath $0))

echo -n $'\E[0;31m'
cat << "EOF"
  
          )   (                  (                                      
       ( /(   )\ )    *   )      )\ )  *   )     (                      
   (   )\()) (()/(  ` )  /( (   (()/(` )  /(     )\      )   )      (   
   )\ ((_)\   /(_))  ( )(_)))\   /(_))( )(_))  (((_)  ( /(  /((    ))\  
  ((_)  ((_) (_))   (_(_())((_) (_)) (_(_())   )\___  )(_))(_))\  /((_) 
  | __|/ _ \ / __|  |_   _|| __|/ __||_   _|  ((/ __|((_)_ _)((_)(_))   
  | _|| (_) |\__ \    | |  | _| \__ \  | |     | (__ / _` |\ V / / -_)  
  |___|\___/ |___/    |_|  |___||___/  |_|      \___|\__,_| \_/  \___|  
                                                                       
EOF
echo -n $'\E[0;32m'

cat << "EOF"
                .        __           ,    .             
                |_   .  /  `._.  .._ -+- _ |   * _ ._  __
                [_)\_|  \__.[  \_|[_) | (_)|___|(_)[ )_) 
                   ._|         ._||                     

EOF
#`

echo -n $'\e[0;39m'



echo "Preparing and clearing..."

#Remove default wallets files in ~/eosio-wallet folder (to clean test)
rm -r ~/eosio-wallet/*

# Remove logs from last testing
rm -r $GLOBALPATH/log/*.dat
rm -r $GLOBALPATH/log/*.log

print_test_result() {
    T_=$1
    T1=$(echo $T_ | cut -d ":" -f 1)
    T2=$(echo $T_ | cut -d ":" -f 2)
    if [[ $T1 -eq 1 ]]; then
	#echo -e "$T2 - \e[32m[OK]\e[39m" | column -t -s- 

	printf '\e[1;39m%-75s\e[m \e[1;32m%-25s\e[m\n' " $T2" "[OK]"
	TEST_OK_WALLET=$(($TEST_OK_WALLET+1))
	TEST_OK=$(($TEST_OK+1))
    else
	#echo -e "$T2 \t \e[31m[FAILED]\e[39m"
	printf '\e[1;39m%-75s\e[m \e[1;31m%-25s\e[m\n' " $T2" "[FAILED]"
	TEST_FAILED_WALLET=$(($TEST_FAILED_WALLET+1))
	TEST_FAILED=$(($TEST_FAILED+1))
    fi

}

startCategoryTest(){
    DIR=$1;

    echo "";
    echo -e "\e[1;39m╔════════════════════╣ \e[1;32m Tests $1 \e[m ╠═══════════════════════════════╗\e[m \n";

    mydir=$(pwd)
    STARTTIME_GROUP=$(date +%s.%N)
    TEST_FAILED_WALLET=0
    TEST_OK_WALLET=0

    cd $1
    for f in *.sh; do
	print_test_result "$(./$f)"
    done
    cd $mydir

    ENDTIME_GROUP=$(date +%s.%N)
    DIFF_GROUP=$(echo "$ENDTIME_GROUP - $STARTTIME_GROUP" | bc)

    echo ""
    echo -e "\e[1;39m┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫\e[m"
    echo " Tests: $1"
    echo " Time: $DIFF_GROUP sec"
    echo -e " Group Total \e[32mOK\e[39m/\e[31mFailed\e[39m/\e[1;39mTotal\e[m tests: \e[32m$TEST_OK_WALLET\e[m/\e[31m$TEST_FAILED_WALLET\e[m/\e[1;39m"$((TEST_OK_WALLET+TEST_FAILED_WALLET))"\e[m"

    echo -e "\e[1;39m╚══════════════════════════════════════════════════════════════════════════════╝\e[m \n";
}


#========================================================================================================================================

echo "START TESTING..."
TEST_FAILED=0
TEST_OK=0

STARTTIME=$(date +%s.%N)

#########################################################################################################################
#########################################################################################################################

startCategoryTest "tests/01_wallet"
startCategoryTest "tests/02_account"

#########################################################################################################################
#########################################################################################################################


ENDTIME=$(date +%s.%N)
DIFF=$(echo "$ENDTIME - $STARTTIME" | bc)

echo ""
echo ""
echo -e "\e[92m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[m"
echo -e "\e[92m▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\e[m"
echo -e "\e[92m▒\e[m"
echo -e "\e[92m▒\e[m  Time: $DIFF sec"
echo -e "\e[92m▒\e[m  Total \e[32mOK\e[39m/\e[31mFailed\e[39m/\e[1;39mTotal\e[m for all tests: \e[32m$TEST_OK\e[m/\e[31m$TEST_FAILED\e[m/\e[1;39m"$((TEST_OK+TEST_FAILED))"\e[m"
echo -e "\e[92m▒\e[m"
echo -e "\e[92m▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\e[m"
echo ""
read -n 1 -s -r -p "Press any key to continue"
echo ""