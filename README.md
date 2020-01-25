# BACnet Unit Tests

This is a script for validating the properties of a BACnet device and its objects. It is recommended to have Docker installed to run this, but the script is runnable without Docker.

## With Docker
Simply run `docker-compose up`.

## Without Docker
#### Requirements:
* GCC
* Git
* Make
#### Building:
* Run `git clone https://git.code.sf.net/p/bacnet/src`.
* Inside the directory created from the clone, run `make`.
* Add the `bin` directory to your `$PATH`.

With all that set up, running `./tests.sh` will invoke the testing.
