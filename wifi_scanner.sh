#!/bin/bash

declare -a rssi_values
declare -a lines
param=2

while true
do
	clear

	rssi=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I |
		grep -i agrCtlRSSI |
		awk '{print $2}')

	rssi=$((rssi / param))
	#rssi_values+=("$rssi")
	for ((value=0; value<=90/param; value++))
		do
			if [[ $value -eq $((-1 * $rssi)) ]]; then
           		lines[$value]+="*"
			else
        		lines[$value]+=" "
        	fi
		done

	for ((i=0; i<${#lines[@]}; i++))
		do
			RED='\033[0;31m'
			GREEN='\033[0;32m'
			YELLOW='\033[0;33m'
			NC='\033[0m'

			if [ $(($i*param)) -lt 50 ]; then
    			echo -e "${GREEN}db -$(($i*param)) ${lines[$i]}${NC}"
			elif [ $(($i*param)) -ge 50 ] && [ $(($i*param)) -le 67 ]; then
				echo -e "${YELLOW}db -$(($i*param)) ${lines[$i]}${NC}"
			else
				echo -e "${RED}db -$(($i*param)) ${lines[$i]}${NC}"
			fi

		done

	length=${#lines[1]}
	if [ $length -eq 200 ]; then
 	   unset lines
	fi
 	sleep 1
done
