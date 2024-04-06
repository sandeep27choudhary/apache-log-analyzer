#!/bin/bash

#check if the log file exists or not

if [[ ! -f $0 ]]; then
    echo "Error: Log file not found: $0"
    exit 1
fi
