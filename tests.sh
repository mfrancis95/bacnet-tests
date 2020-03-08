DEVICE_OBJECT_TYPE=8

check_executable() {
    if type $1 &> /dev/null; then
        success "$1 executable found."
    else
        failure "$1 executable not found. Can't continue with the rest of the tests."
        exit 1
    fi
}

compare() {
    if [ "$2" == "$3" ]; then
        success "Passed $1 test. Expected value: $2."
    else
        failure "Failed $1 test. Returned value $3 does not match expected value $2."
    fi
}

failure() {
    message 31 "$1"
}

info() {
    message 34 "$1"
}

message() {
    echo -e "\e[$1m$2"
}

read_property() {
    grep $2 $DEVICE_MAPPING_FILE > temp.txt
    read property property_id < temp.txt
    value=$(bacrp $1 $DEVICE_OBJECT_TYPE 0 $property_id)
    value=${value::-1}
}

success() {
    message 32 "$1"
}

info 'Starting tests...'

info 'Checking location of bacwi executable...'
check_executable bacwi

info 'Running Who-Is test...'
bacwi > /dev/null 2> temp.txt
# Received I-Am Request from $device_id, MAC = $ip BAC0
read received iam request from device_id mac equals ip bac0 < temp.txt
if [ "$received" != Received ]; then
    failure "Failed Who-Is test. Can't continue with the rest of the tests because a device hasn't been found."
    exit 1
fi
device_id=${device_id::-1}
success "Passed Who-Is test. Device ID = $device_id."

if [ "$SKIP_READ" ]; then
    info 'Skipping Device Read Property tests...'
else
    info 'Checking location of bacrp executable...'
    check_executable bacrp

    info 'Running Device Read Property tests...'
    IFS='='
    read_property $device_id Object_Identifier
    compare Object_Identifier '(device, 0)' "$value"
    read_property $device_id Object_Type
    compare Object_Type $DEVICE_OBJECT_TYPE $value
    while read property expected; do
        read_property $device_id $property
        compare $property $expected $value
    done < $DEVICE_FILE
fi

info 'Finished running tests.'
