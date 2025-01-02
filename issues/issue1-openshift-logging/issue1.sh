#!/bin/bash
# Script: issue1.sh
# Author: Hoang Thanh VO

readonly LOG_DATETIME=$(date +'%Y%m%d_%H%M%S')
readonly LOG_PODS_PATH="/var/log/pods"

# Provide the oc login command for authentication
read -s -p "Enter the oc login command: "$'\n' command

# Give the name of the target worker node
read -p "Provide the name of the worker node: "$'\n' node

# Log in to the cluster
eval "${command}" 1>/dev/null

# Display the current limit for open files
echo "Open files limit:" $(oc debug node/"${node}" -q -- ulimit -n)

# Display the number of open files
echo "Count open files:" $(oc debug node/"${node}" -q -- cat /proc/sys/fs/file-nr | awk '{ print $1 }')

# Count open log files
echo "Count open files (in ${LOG_PODS_PATH}):" $(oc debug node/"${node}" -q -- chroot /host lsof +D "${LOG_PODS_PATH}" | wc -l)

# Get current open log files
oc debug node/"${node}" -q -- chroot /host lsof +D "${LOG_PODS_PATH}" > /tmp/${LOG_DATETIME}_issue1.log