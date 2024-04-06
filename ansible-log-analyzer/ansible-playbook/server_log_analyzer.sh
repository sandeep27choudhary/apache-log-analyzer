#!/bin/bash

# Check if log file argument is provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

# Check if log file exists
if [[ ! -f $1 ]]; then
    echo "Error: Log file not found: $1"
    exit 1
fi

# Read the log file and sum up the bytes transmitted for each request
total_requests=0
total_bytes_transmitted=0

while IFS= read -r line; do
    ((total_requests++))
    bytes_transmitted=$(echo "$line" | awk '{print $10}')
    ((total_bytes_transmitted += bytes_transmitted))
done < "$1"

# Convert bytes to gigabytes
total_gb_transmitted=$(awk "BEGIN {printf \"%.2f\", $total_bytes_transmitted / (1024 * 1024 * 1024)}")

# Run the command to find the most requested resource and store the result in a variable
most_requested_resource_info=$(awk '{print $7}' "$1" | grep -v '^-$' | sort | uniq -c | sort -nr | head -n 1)
most_requested_resource_count=$(echo "$most_requested_resource_info" | awk '{print $1}')
most_requested_resource_name=$(echo "$most_requested_resource_info" | awk '{print $2}')
percentage_requests=$(awk "BEGIN {printf \"%.2f\", ($most_requested_resource_count / $total_requests) * 100}")

# Find the remote host with the most requests
most_requested_host=$(awk '{count[$1]++} END {for (host in count) print host, count[host]}' "$1" | sort -k2nr | head -n1)
most_requested_host_name=$(echo "$most_requested_host" | awk '{print $1}')
most_requested_host_count=$(echo "$most_requested_host" | awk '{print $2}')
percentage_requests=$(awk "BEGIN {printf \"%.2f\", ($most_requested_host_count / $total_requests) * 100}")

# Print all the required details:

echo "Total number of requests: $total_requests"
echo "Total data transmitted: ${total_gb_transmitted}GB"
echo "Most requested resource: ${most_requested_resource_name}"
echo "Total requests for ${most_requested_resource_name}: ${most_requested_resource_count}"
echo "Percentage of requests for ${most_requested_resource_name}: ${percentage_requests}"
echo "Remote host with the most requests: $most_requested_host_name"
echo "Total requests from $most_requested_host_name: $most_requested_host_count"
echo "Percentage of requests from $most_requested_host_name: $percentage_requests%"

# Use awk to count the total number of requests and the number of requests for each status code range

awk '
    { 
        total_requests++
        status_code_prefix = substr($9, 1, 1) # Extract the first character
        for (i = 1; i <= 5; i++) { # Loop from 1 to 5
            if (status_code_prefix == i) { # Check if the prefix matches
                status_code_counts[i]++
                break; # Break the loop once a match is found
            }
        }
    }
    END {
        if (total_requests == 0) {
            print "No requests found in the log file"
            exit
        }
        for (prefix = 1; prefix <= 5; prefix++) { # Loop from 1 to 5
            percentage = (status_code_counts[prefix] / total_requests) * 100
            printf "Percentage of %dxx requests: %.2f%%\n", prefix, percentage
        }
    }
' "$1"
