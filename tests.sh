#!/bin/sh

failure() {
    message 31 "$1"
}

info() {
    message 34 "$1"
}

message() {
    echo -e "\e[$1m$2"
}

success() {
    message 32 "$1"
}

# Who-Is Test
info 'Running Who-Is test...'
bacwi > /dev/null 2> temp.txt
# Received I-Am Request from $device_id, MAC = $ip BAC0
read received iam request from device_id mac equals ip bac0 < temp.txt
if [ "$received" != Received ]; then
    failure "Failed Who-Is test. Can't continue with the rest of the tests because a device hasn't been found."
    exit 1
fi
device_id=${device_id::-1}
success 'Passed Who-Is test.'
