DEVICE_OBJECT_TYPE=8

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

# Who-Is Test
info 'Running Who-Is test...'
if ! type bacwi &> /dev/null; then
    failure "Failed Who-Is test. bacwi executable wasn't found."
    exit 1
fi
bacwi > /dev/null 2> temp.txt
# Received I-Am Request from $device_id, MAC = $ip BAC0
read received iam request from device_id mac equals ip bac0 < temp.txt
if [ "$received" != Received ]; then
    failure "Failed Who-Is test. Can't continue with the rest of the tests because a device hasn't been found."
    exit 1
fi
device_id=${device_id::-1}
success 'Passed Who-Is test.'

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
info 'Finished running tests.'
