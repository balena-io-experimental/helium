#!/bin/bash

if [ -z ${MODEL} ] ;
 then
    echo -e "\033[91mWARNING: MODEL variable not set.\n Set the model of the gateway you are using."
    balena-idle
 else
    echo "Using MODEL: $MODEL"
    if [ $MODEL = "RAK2245" ];then
        ./start_rak2245.sh

    fi
    if [ $MODEL = "RAK2287" ];then
        ./start_rak2287.sh
    fi
fi 
