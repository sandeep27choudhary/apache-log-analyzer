#!/bin/bash


# Check if log file argument is provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

#check if the log file exists or not
if [[ ! -f $1 ]]; then
    echo "Error: Log file not found: $1"
    exit 1
fi
