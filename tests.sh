#!/bin/sh

# Who-Is Test
echo -e '\e[34mRunning Who-Is test...'
bacwi > /dev/null 2> temp.txt
# Received I-Am Request from $device_id, MAC = $ip BAC0
read received iam request from device_id mac equals ip bac0 < temp.txt
if [ "$received" != Received ]; then
    echo -e "\e[31mFailed Who-Is test. Can't continue with the rest of the tests because a device hasn't been found."
    exit 1
fi
device_id=${device_id::-1}
echo -e '\e[32mPassed Who-Is test.'
