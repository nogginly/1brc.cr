#!/bin/sh

# $1 app name
# $2 thread count
# $3 buffer division

CRYSTAL_WORKERS=$2 BUF_DIV_DENOM=$3 $(dirname $0)/bin/$1 measurements.txt $(dirname $0)/out/$1_D$2_B$3.txt
